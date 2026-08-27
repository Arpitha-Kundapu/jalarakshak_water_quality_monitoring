import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  // ============================================================
  // FIREBASE REALTIME DATABASE
  // ============================================================

  static const String firebaseUrl =
      'https://jalrakshak-app-26-default-rtdb.asia-southeast1.firebasedatabase.app';

  static const String devicePath =
      '/devices/device_001';

  // ============================================================
  // GET LATEST SENSOR DATA
  // ============================================================

  Future<Map<String, dynamic>> getLatestSensorData() async {
    final response = await http.get(
      Uri.parse(
        '$firebaseUrl$devicePath/latest.json',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Firebase latest data error: '
        '${response.statusCode}\n${response.body}',
      );
    }

    if (response.body == 'null') {
      throw Exception(
        'No sensor data found in Firebase.',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid sensor data received from Firebase.',
      );
    }

    return Map<String, dynamic>.from(decoded);
  }

  // ============================================================
  // GET ML PREDICTION
  // ============================================================

  Future<Map<String, dynamic>> getPrediction() async {
    final response = await http.get(
      Uri.parse(
        '$firebaseUrl$devicePath/prediction.json',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Firebase prediction error: '
        '${response.statusCode}\n${response.body}',
      );
    }

    if (response.body == 'null') {
      throw Exception(
        'No ML prediction found in Firebase.',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid prediction data received from Firebase.',
      );
    }

    return Map<String, dynamic>.from(decoded);
  }

  // ============================================================
  // GET COMPLETE WATER QUALITY DATA
  // ============================================================

  Future<Map<String, dynamic>> getWaterQuality() async {
    final sensorData = await getLatestSensorData();

    final prediction = await getPrediction();

    return {
      'sensor_data': sensorData,
      'prediction': prediction,
    };
  }

  // ============================================================
  // GET HISTORY
  // ============================================================
  //
  // Firebase:
  //
  // /devices/device_001/history
  //
  //     |- -Pxxxxx
  //     |     |- raw_tds
  //     |     |- raw_turbidity
  //     |     |- tds
  //     |     |- tds_mg_L
  //     |     |- turbidity
  //     |     |- turbidity_NTU
  //     |     |- timestamp
  //     |
  //     |- -Pxxxxx
  //
  // ============================================================

  Future<List<Map<String, dynamic>>> getHistory() async {
    final response = await http.get(
      Uri.parse(
        '$firebaseUrl$devicePath/history.json',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Firebase history error: '
        '${response.statusCode}\n${response.body}',
      );
    }

    if (response.body == 'null') {
      return [];
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid history data received from Firebase.',
      );
    }

    final List<Map<String, dynamic>> history = [];

    decoded.forEach((key, value) {
      if (value is Map) {
        final record = Map<String, dynamic>.from(value);

        // Store Firebase push ID.
        record['_id'] = key;

        history.add(record);
      }
    });

    // ------------------------------------------------------------
    // SORT BY TIMESTAMP
    // ------------------------------------------------------------

    history.sort((a, b) {
      final int timestampA =
          int.tryParse(
                a['timestamp']?.toString() ?? '0',
              ) ??
              0;

      final int timestampB =
          int.tryParse(
                b['timestamp']?.toString() ?? '0',
              ) ??
              0;

      return timestampB.compareTo(timestampA);
    });

    return history;
  }
}