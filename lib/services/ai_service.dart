import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  Future<String> predictDisease(File imageFile) async {
    final apiKey = '';//"r8_5OL7X7gFoSDRMkNWQtalGQ6GIqVjGl74HCnjX";
    final modelVersion =" ";// "95fcc2a26d3899cd6c2691c900465aaeff466285a65c14638cc5f36f34befaf1";
  //lucataco/remove-bg:95fcc2a26d3899cd6c2691c900465aaeff466285a65c14638cc5f36f34befaf1
    print("📸 Uploading image...");
    final imageUrl = await uploadToImgbb(imageFile);

    final url = Uri.parse("https://api.replicate.com/v1/predictions");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "version": modelVersion,
        "input": {
          "image": imageUrl,
        }
      }),
    );

    print("📥 Status: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final output = data['output']; // adjust if it's a URL or list
      return output.toString();
    } else {
      return "❌ Error: ${response.body}";
    }
  }

  Future<String> uploadToImgbb(File imageFile) async {
    final imgbbApiKey = " ";//"bf21d533025bf4e02bb0c4bd7fd93c74"; // get from imgbb.com
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey");

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final response = await request.send();

    final respStr = await response.stream.bytesToString();
    final jsonData = jsonDecode(respStr);

    if (jsonData['success'] == true) {
      return jsonData['data']['url'];
    } else {
      throw Exception("Image upload failed");
    }
  }
}
