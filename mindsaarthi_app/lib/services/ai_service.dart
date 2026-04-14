import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mindsaarthi_app/core/config/api_config.dart';

class AIService {
  static Future<Map<String, dynamic>> getAIResponse(String mood) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": "I am feeling $mood"}),
    );

    final data = jsonDecode(response.body);

    return {"reply": data["reply"], "actions": data["actions"] ?? []};
  }

  static Future<String> getDailyThought() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/daily-thought"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["thought"];
    } else {
      return "Every day is a new opportunity to grow.";
    }
  }
}
