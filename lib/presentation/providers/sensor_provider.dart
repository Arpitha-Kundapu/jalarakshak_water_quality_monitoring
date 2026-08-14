import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/sensor_data.dart';

// ============================================================================
// DEMO SENSOR PROVIDER
// ============================================================================
//
// This currently simulates ESP32 sensor readings.
//
// Later:
// ESP32 → Backend → ML Model → Flutter
//
// For now:
// Demo Sensor → Flutter
//
// The simulator generates SAFE, WARNING and UNSAFE conditions so that
// all UI states can be tested before the backend and ML are implemented.
// ============================================================================

final liveSensorProvider = StreamProvider<SensorData>((ref) {
  final random = Random();

  return Stream.periodic(const Duration(seconds: 3), (_) {
    // ================================================================
    // RANDOMLY SELECT A WATER CONDITION
    // ================================================================

    final int condition = random.nextInt(5);

    double ph;
    double tds;
    double turbidity;
    double wqi;
    String status;

    // ================================================================
    // CONDITION 0
    // SAFE WATER
    // ================================================================

    if (condition == 0) {
      ph = 6.8 + random.nextDouble() * 1.2;
      tds = 180 + random.nextDouble() * 180;
      turbidity = 0.5 + random.nextDouble() * 2.5;

      wqi = 85 + random.nextDouble() * 12;

      status = wqi >= 90 ? "SAFE (Excellent)" : "SAFE (Good)";
    }
    // ================================================================
    // CONDITION 1
    // SAFE / GOOD WATER
    // ================================================================
    else if (condition == 1) {
      ph = 7.0 + random.nextDouble() * 1.0;
      tds = 250 + random.nextDouble() * 180;
      turbidity = 1.0 + random.nextDouble() * 2.5;

      wqi = 80 + random.nextDouble() * 10;

      status = "SAFE (Good)";
    }
    // ================================================================
    // CONDITION 2
    // HIGH TDS
    // ================================================================
    else if (condition == 2) {
      ph = 6.8 + random.nextDouble() * 1.2;

      // High TDS
      tds = 550 + random.nextDouble() * 350;

      turbidity = 1.0 + random.nextDouble() * 3.0;

      wqi = 45 + random.nextDouble() * 20;

      status = "UNSAFE (High TDS)";
    }
    // ================================================================
    // CONDITION 3
    // HIGH TURBIDITY
    // ================================================================
    else if (condition == 3) {
      ph = 6.8 + random.nextDouble() * 1.2;

      tds = 200 + random.nextDouble() * 250;

      // High turbidity
      turbidity = 6 + random.nextDouble() * 10;

      wqi = 40 + random.nextDouble() * 25;

      status = "UNSAFE (High Turbidity)";
    }
    // ================================================================
    // CONDITION 4
    // ABNORMAL pH + MULTIPLE RISKS
    // ================================================================
    else {
      // Abnormal pH
      if (random.nextBool()) {
        ph = 5.0 + random.nextDouble() * 1.0;
      } else {
        ph = 9.0 + random.nextDouble() * 1.0;
      }

      // Also make TDS/turbidity somewhat high
      tds = 550 + random.nextDouble() * 400;

      turbidity = 6 + random.nextDouble() * 10;

      wqi = 25 + random.nextDouble() * 25;

      status = "UNSAFE (Multiple Risks)";
    }

    // ================================================================
    // RETURN SENSOR DATA
    // ================================================================

    return SensorData(
      wqi: wqi,
      ph: ph,
      tds: tds,
      turbidity: turbidity,
      status: status,
    );
  });
});
