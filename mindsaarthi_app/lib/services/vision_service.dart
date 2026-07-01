import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mindsaarthi_app/core/config/api_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VisionService {
  static Future<Map<String, dynamic>> analyzeImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConfig.baseUrl}/analyze-face"),
    );

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();
    var res = await http.Response.fromStream(response);

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> analyzeVideo(File video) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConfig.baseUrl}/analyze-video"),
    );

    request.files.add(await http.MultipartFile.fromPath('file', video.path));

    var response = await request.send();
    var res = await http.Response.fromStream(response);
    print("API RESPONSE: ${res.body}");
    return jsonDecode(res.body);
  }

  static Future<void> saveImageAnalysis(Map<String, dynamic> result) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("vision_images")
        .add({"result": result, "timestamp": FieldValue.serverTimestamp()});
  }

  static Future<void> saveVideoAnalysis(Map<String, dynamic> result) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("vision_videos")
        .add({"result": result, "timestamp": FieldValue.serverTimestamp()});
  }
}
