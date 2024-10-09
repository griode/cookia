import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

CompressFormat getFormat(String extension) {
  switch (extension) {
    case "png":
      return CompressFormat.png;
    case "jpeg":
      return CompressFormat.jpeg;
    case "webp":
      return CompressFormat.webp;
    case "heic":
      return CompressFormat.heic;
    default:
      return CompressFormat.jpeg;
  }
}

Future<File> compressImage(File file, String targetPath) async {
  Directory path = await getApplicationDocumentsDirectory();
  final extension = file.absolute.path.split('.').last;
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    "${path.path}${DateTime.now().millisecondsSinceEpoch}.${getFormat(extension).name}",
    quality: 25,
    keepExif: true,
    format: getFormat(extension),
    numberOfRetries: 10,
  );
  return File(result!.path);
}
