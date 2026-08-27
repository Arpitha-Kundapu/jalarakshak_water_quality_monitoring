import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/sensor_data.dart';
import '../services/sensor_service.dart';

// ============================================================
// SENSOR SERVICE PROVIDER
// ============================================================

final sensorServiceProvider = Provider<SensorService>((ref) {
  return SensorService();
});


// ============================================================
// LIVE SENSOR PROVIDER
// ============================================================
//
// DATA FLOW:
//
// ESP32
//   ↓
// Firebase /latest
//   ↓
// Python Random Forest
//   ↓
// Firebase /prediction
//   ↓
// Flutter
//
// ============================================================

final liveSensorProvider = StreamProvider<SensorData>((ref) async* {
  final sensorService = ref.read(sensorServiceProvider);

  while (true) {
    try {
      // ========================================================
      // GET SENSOR + ML DATA FROM FIREBASE
      // ========================================================

      final result = await sensorService.getWaterQuality();

      // ========================================================
      // SENSOR DATA
      // ========================================================

      final Map<String, dynamic> sensorData =
          result['sensor_data'] is Map
              ? Map<String, dynamic>.from(
                  result['sensor_data'],
                )
              : {};

      // ========================================================
      // ML PREDICTION DATA
      // ========================================================

      final Map<String, dynamic> predictionData =
          result['prediction'] is Map
              ? Map<String, dynamic>.from(
                  result['prediction'],
                )
              : {};

      // ========================================================
      // TDS
      // ========================================================

      final double tds = _toDouble(
        sensorData['tds_mg_L'],
        0,
      );

      // ========================================================
      // TURBIDITY
      // ========================================================

      final double turbidity = _toDouble(
        sensorData['turbidity_NTU'],
        0,
      );

      // ========================================================
      // pH
      // ========================================================
      //
      // There is currently no pH sensor in the hardware.
      //
      // We keep 7.0 temporarily so the existing dashboard
      // continues to work.
      //
      // ========================================================

      const double ph = 7.0;

      // ========================================================
      // ML CLASSIFICATION
      // ========================================================

      final String classification =
          predictionData['classification']?.toString() ??
              'Waiting for prediction';

      // ========================================================
      // ML PROBABILITIES
      // ========================================================

      final Map<String, dynamic> rawProbabilities =
          predictionData['probabilities'] is Map
              ? Map<String, dynamic>.from(
                  predictionData['probabilities'],
                )
              : {};

      // Convert Map<String, dynamic> → Map<String, double>
      final Map<String, double> probabilities =
          rawProbabilities.map(
        (key, value) {
          return MapEntry(
            key,
            _toDouble(value, 0),
          );
        },
      );

      // ========================================================
      // WQI
      // ========================================================
      //
      // This is currently a display-level score.
      //
      // It is NOT the Random Forest probability.
      //
      // ========================================================

      final double wqi = _calculateWqi(
        tds: tds,
        turbidity: turbidity,
      );

      // ========================================================
      // CREATE SENSOR DATA OBJECT
      // ========================================================

      final sensor = SensorData(
        wqi: wqi,
        ph: ph,
        tds: tds,
        turbidity: turbidity,
        status: classification,

        // NEW
        probabilities: probabilities,
      );

      // ========================================================
      // SEND DATA TO FLUTTER UI
      // ========================================================

      yield sensor;

      // ========================================================
      // DEBUG INFORMATION
      // ========================================================

      print('');
      print('========================================');
      print('JALRAKSHAK FIREBASE DATA');
      print('========================================');

      print(
        'TDS: $tds mg/L',
      );

      print(
        'Turbidity: $turbidity NTU',
      );

      print(
        'pH: $ph',
      );

      print(
        'Classification: $classification',
      );

      print(
        'Probabilities: $probabilities',
      );

      print(
        'WQI: $wqi',
      );

      print('========================================');
    } catch (e) {
      // ========================================================
      // FIREBASE / CONNECTION ERROR
      // ========================================================

      print(
        'JalRakshak Firebase Error: $e',
      );

      yield SensorData(
        wqi: 0,
        ph: 7.0,
        tds: 0,
        turbidity: 0,
        status: 'Connection Error',

        probabilities: const {},
      );
    }

    // ==========================================================
    // REFRESH EVERY 5 SECONDS
    // ==========================================================

    await Future.delayed(
      const Duration(seconds: 5),
    );
  }
});


// ============================================================
// SAFE DOUBLE CONVERSION
// ============================================================

double _toDouble(
  dynamic value,
  double fallback,
) {
  if (value is num) {
    return value.toDouble();
  }

  final parsed = double.tryParse(
    value?.toString() ?? '',
  );

  return parsed ?? fallback;
}


// ============================================================
// TEMPORARY DISPLAY WQI
// ============================================================
//
// NOTE:
// This is NOT the Random Forest prediction.
//
// It is only retained so your existing dashboard's WQI card
// continues to function.
//
// We can replace this with the final WQI methodology later.
//
// ============================================================

double _calculateWqi({
  required double tds,
  required double turbidity,
}) {
  double score = 100;

  // ------------------------------------------------------------
  // TDS
  // ------------------------------------------------------------

  if (tds > 1000) {
    score -= 40;
  } else if (tds > 500) {
    score -= 25;
  } else if (tds > 300) {
    score -= 10;
  }

  // ------------------------------------------------------------
  // TURBIDITY
  // ------------------------------------------------------------

  if (turbidity > 5) {
    score -= 30;
  } else if (turbidity > 3) {
    score -= 15;
  } else if (turbidity > 1) {
    score -= 5;
  }

  return score.clamp(0, 100).toDouble();
}