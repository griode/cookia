import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// Purpose: Upload file to server and return the file url
Future<String> uploadFile(File file, String ref) async {
  String fileName =
      "${DateTime.now().millisecondsSinceEpoch}.${file.absolute.path.split('.').last}";

  Reference storageReference =
      FirebaseStorage.instance.ref().child('$ref/$fileName');
  try {
    // Upload file to server
    await storageReference.putFile(file);
    // Return the file url
    return storageReference.getDownloadURL();
  } catch (e) {
    // Handle error
    debugPrint(e.toString());
    return "";
  }
}

// Upload by url
Future<String> uploadImageFromUrl(String imageUrl, String storagePath, String extension) async {

  // Fetch the image from the URL
  final http.Response response = await http.get(Uri.parse(imageUrl));

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Create a temporary file to save the image
    final Directory tempDir = Directory.systemTemp;
    final File tempFile = File('${tempDir.path}/${"${DateTime.now().millisecondsSinceEpoch}.$extension"}');

    // Write the image bytes to the file
    await tempFile.writeAsBytes(response.bodyBytes);
    // Upload the image to the server
    String imageUrl = await uploadFile(tempFile, storagePath);

    return imageUrl;
  } else {
    return "";
  }
}
