import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/sensor_data.dart';
import '../../services/sensor_service.dart';

final sensorServiceProvider = Provider<SensorService>((ref) {
  return SensorService();
});

final liveSensorProvider = StreamProvider<SensorData>((ref) async* {
  final sensorService = ref.read(sensorServiceProvider);

  // ================================================================
  // TEMPORARY SENSOR VALUES
  // ================================================================
  //
  // For now:
  //
  // TDS + Turbidity
  //       ↓
  // Node.js Backend
  //       ↓
  // Python ML Model
  //       ↓
  // Classification
  //
  // Later:
  //
  // ESP32 → Node.js → ML → Flutter
  //
  // ================================================================

  const double testTds = 250;
  const double testTurbidity = 0.5;

  // ------------------------------------------------
  // TEMPORARY pH
  // ------------------------------------------------
  // Keep pH because it is part of the project/report.
  // Later this value will come from the ESP32 pH sensor.
  // ------------------------------------------------

  const double testPh = 7.2;

  while (true) {
    try {
      // ============================================================
      // SEND DATA TO BACKEND
      // ============================================================

      final result = await sensorService.getWaterQuality(
        tds: testTds,
        turbidity: testTurbidity,
      );

      // ============================================================
      // READ SENSOR DATA
      // ============================================================

      final Map<String, dynamic> sensorData =
          result['sensor_data'] is Map
              ? Map<String, dynamic>.from(
                  result['sensor_data'],
                )
              : {};

      // ============================================================
      // READ ML CLASSIFICATION
      // ============================================================

      final String classification =
          result['classification']?.toString() ?? 'Unknown';

      // ============================================================
      // READ ML PROBABILITIES
      // ============================================================

      final Map<String, dynamic> probabilities =
          result['probabilities'] is Map
              ? Map<String, dynamic>.from(
                  result['probabilities'],
                )
              : {};

      // ============================================================
      // GET TDS
      // ============================================================

      final double tds =
          _toDouble(
            sensorData['tds'],
            testTds,
          );

      // ============================================================
      // GET TURBIDITY
      // ============================================================

      final double turbidity =
          _toDouble(
            sensorData['turbidity'],
            testTurbidity,
          );

      // ============================================================
      // CALCULATE DISPLAY WQI
      // ============================================================
      //
      // IMPORTANT:
      // This is a temporary display score.
      //
      // It is NOT the ML probability.
      //
      // Later we can implement the final WQI formula based on
      // the parameters coming from ESP32.
      //
      // ============================================================

      final double wqi =
          _calculateTemporaryWqi(
        tds: tds,
        turbidity: turbidity,
        ph: testPh,
      );

      // ============================================================
      // SEND DATA TO DASHBOARD
      // ============================================================

      yield SensorData(
        wqi: wqi,
        ph: testPh,
        tds: tds,
        turbidity: turbidity,
        status: classification,
      );

      // ============================================================
      // DEBUG INFORMATION
      // ============================================================

      print('----------------------------------------');
      print('JalRakshak ML Response');
      print('TDS: $tds');
      print('Turbidity: $turbidity');
      print('pH: $testPh');
      print('Classification: $classification');
      print('Probabilities: $probabilities');
      print('Temporary WQI: $wqi');
      print('----------------------------------------');
    } catch (e) {
      // ============================================================
      // BACKEND ERROR
      // ============================================================

      print(
        'JalRakshak Backend Error: $e',
      );

      yield SensorData(
        wqi: 0,
        ph: testPh,
        tds: testTds,
        turbidity: testTurbidity,
        status: 'Backend Error',
      );
    }

    // ================================================================
    // REFRESH EVERY 3 SECONDS
    // ================================================================

    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
});

// ====================================================================
// SAFE DOUBLE CONVERSION
// ====================================================================

double _toDouble(
  dynamic value,
  double fallback,
) {
  if (value is num) {
    return value.toDouble();
  }

  final double? parsed =
      double.tryParse(
    value?.toString() ?? '',
  );

  return parsed ?? fallback;
}

// ====================================================================
// TEMPORARY WQI CALCULATION
// ====================================================================
//
// This is only for the current integration/testing stage.
//
// It keeps the Dashboard's WQI card working while the actual
// ESP32 sensor values and final WQI methodology are integrated.
//
// ====================================================================

double _calculateTemporaryWqi({
  required double tds,
  required double turbidity,
  required double ph,
}) {
  double score = 100;

  // TDS contribution
  if (tds > 500) {
    score -= 25;
  } else if (tds > 300) {
    score -= 10;
  }

  // Turbidity contribution
  if (turbidity > 5) {
    score -= 25;
  } else if (turbidity > 3) {
    score -= 10;
  }

  // pH contribution
  if (ph < 6.5 || ph > 8.5) {
    score -= 25;
  }

  return score.clamp(0, 100).toDouble();
}