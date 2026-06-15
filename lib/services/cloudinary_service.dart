import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'deic5bsrc';

  static const String uploadPreset =
      'hidden_gems_upload';

  Future<String?> uploadImage(
    File imageFile,
  ) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request =
          http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['upload_preset'] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response =
          await request.send();

      if (response.statusCode == 200) {
        final responseData =
            await response.stream.bytesToString();

        final data =
            jsonDecode(responseData);

        return data['secure_url'];
      }

      return null;
    } catch (e) {
      print(
        'Cloudinary upload error: $e',
      );
      return null;
    }
  }
}