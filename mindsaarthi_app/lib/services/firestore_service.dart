import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future<void> saveChat({
    required String message,
    required String reply,
    required String sentiment,
    required int risk,
    required String suggestion,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("chats")
        .add({
      "message": message,
      "reply": reply,
      "sentiment": sentiment,
      "risk": risk,
      "suggestion": suggestion,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}