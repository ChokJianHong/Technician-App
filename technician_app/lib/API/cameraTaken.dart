import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String token; // Accept the token here

  const DisplayPictureScreen(
      {Key? key, required this.imagePath, required this.token})
      : super(key: key);

  Future<void> _uploadPicture(
      BuildContext context, String imagePath, String token) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw Exception(
            'File does not exist at the specified path: $imagePath');
      }

      var uri = Uri.parse(
          'http://10.0.2.2:5005/dashboarddatabase/orders'); // Adjust this URL to your server endpoint
      var request = http.MultipartRequest('POST', uri);

      // Attach the token to the headers
      request.headers['Authorization'] = token;
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.headers['userType'] = 'customer';

      // Attach the file to the request
      var filePart = await http.MultipartFile.fromPath('image', imagePath,
          filename: path.basename(imagePath));
      request.files.add(filePart);

      var response = await request.send();

      print('Response status: ${response.statusCode}');
      final responseData = await response.stream.bytesToString();
      print('Response body: $responseData');

      if (response.statusCode == 201) {
        final jsonData = json.decode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload successful! Image URL: ${jsonData['url']}')),
        );
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath))),
          ElevatedButton(
            onPressed: () => _uploadPicture(
                context, imagePath, token), // Pass the token here
            child: const Text('Upload Picture'),
          ),
        ],
      ),
    );
  }
}
