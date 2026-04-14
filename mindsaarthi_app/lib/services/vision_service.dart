import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mindsaarthi_app/core/config/api_config.dart';

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
}
