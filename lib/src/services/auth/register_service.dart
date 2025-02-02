import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  final String baseUrl = "http://192.168.100.11:8000/api/register/";

  Future<bool> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}