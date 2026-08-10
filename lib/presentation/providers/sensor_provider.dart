import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sensor_data.dart';

// This stream simulates your ESP32 sending data every 3 seconds
final liveSensorProvider = StreamProvider<SensorData>((ref) {
  return Stream.periodic(const Duration(seconds: 3), (_) {
    final random = Random();
    
    // Generating realistic mock data based on your limits
    double ph = 6.5 + random.nextDouble() * 2.0; // 6.5 to 8.5
    double tds = 150 + random.nextDouble() * 200; // 150 to 350 ppm
    double turbidity = random.nextDouble() * 4.0; // 0 to 4 NTU
    double wqi = 75 + random.nextDouble() * 20; // 75 to 95 Score
    
    String status = wqi >= 90 ? "SAFE (Excellent)" : "SAFE (Good)";

    return SensorData(
      wqi: wqi,
      ph: ph,
      tds: tds,
      turbidity: turbidity,
      status: status,
    );
  });
});