import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mindsaarthi_app/core/config/api_config.dart';

class JournalService {
  static Future<void> saveEntry(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("journal")
        .add({"text": text, "timestamp": FieldValue.serverTimestamp()});
  }

  static Future<List<String>> getSuggestions() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/journal-suggestions'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['suggestions']);
      } else {
        return [
          "What made you smile today?",
          "How did you handle stress today?",
          "What are you grateful for?",
        ];
      }
    } catch (e) {
      return [
        "What made you smile today?",
        "How did you handle stress today?",
        "What are you grateful for?",
      ];
    }
  }
}
