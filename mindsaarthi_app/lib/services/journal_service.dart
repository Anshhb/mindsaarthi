import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalService {
  static Future<void> saveEntry(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("journal")
        .add({
      "text": text,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}