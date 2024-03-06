import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRequest {
  static Future<String> login(String username, String password) async {
    try {
      final host = '<Your Host>';
      final url = '$host/data/api/login';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw 'Request failed with status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Request error: $error';
    }
  }
}
