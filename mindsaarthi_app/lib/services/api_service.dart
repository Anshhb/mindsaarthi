import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mindsaarthi_app/core/config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": message}),
    );

    return jsonDecode(response.body);
  }
}
