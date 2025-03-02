import 'dart:convert';
import 'package:http/http.dart' as http;

class PocketBaseAuthService {
  final String baseUrl = 'https://desktop-og46q9s.tail7d5586.ts.net';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/collections/users/auth-with-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'identity': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/collections/users/records'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'passwordConfirm': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> adminlogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/collections/administrator/auth-with-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'identity': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to log in');
    }
  }
}
