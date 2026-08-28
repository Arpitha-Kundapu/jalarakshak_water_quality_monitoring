import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AuthService {
  // Determine local backend server URL dynamically
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000';
      }
    } catch (_) {}
    return 'http://localhost:5000';
  }

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': decoded['message'] ?? 'Login successful',
          'user': decoded['user'],
        };
      } else {
        return {
          'success': false,
          'message': decoded['message'] ?? 'Invalid email or password',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please check your connection.',
      };
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': decoded['message'] ?? 'User registered successfully',
          'user': decoded['user'],
        };
      } else {
        return {
          'success': false,
          'message': decoded['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please check your connection.',
      };
    }
  }
}
