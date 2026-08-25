import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  // Flutter Web / Edge
  static const String baseUrl = 'http://localhost:5000';

  Future<Map<String, dynamic>> getWaterQuality({
    required double tds,
    required double turbidity,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/predict'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tds': tds,
        'turbidity': turbidity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Backend error: ${response.statusCode}\n${response.body}',
      );
    }

    return jsonDecode(response.body);
  }
}