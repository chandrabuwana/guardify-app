import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressUtil {
  static const int maxBytes1Mb = 1024 * 1024;

  static bool isImagePath(String filePath) {
    final lower = filePath.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.heic') ||
        lower.endsWith('.webp');
  }

  static Future<File> ensureMax1MbIfImage(
    String inputPath, {
    int maxBytes = maxBytes1Mb,
  }) async {
    if (!isImagePath(inputPath)) {
      final f = File(inputPath);
      if (!await f.exists()) {
        throw Exception('File not found');
      }
      return f;
    }
    return compressToMax1Mb(inputPath, maxBytes: maxBytes);
  }

  static Future<File> compressToMax1Mb(
    String inputPath, {
    int maxBytes = maxBytes1Mb,
  }) async {
    final inputFile = File(inputPath);
    if (!await inputFile.exists()) {
      throw Exception('Image file not found');
    }

    final inputBytes = await inputFile.length();
    if (inputBytes <= maxBytes) {
      return inputFile;
    }

    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/cmp_${DateTime.now().millisecondsSinceEpoch}.jpg';

    int quality = 92;
    int minWidth = 1920;
    int minHeight = 1920;

    File? best;

    for (int i = 0; i < 8; i++) {
      final out = await FlutterImageCompress.compressAndGetFile(
        inputPath,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      if (out == null) {
        break;
      }

      final outFile = File(out.path);
      best = outFile;

      final outBytes = await outFile.length();
      if (outBytes <= maxBytes) {
        return outFile;
      }

      quality = (quality * 0.75).round();
      if (quality < 35) quality = 35;

      minWidth = (minWidth * 0.85).round();
      minHeight = (minHeight * 0.85).round();
      if (minWidth < 720) minWidth = 720;
      if (minHeight < 720) minHeight = 720;
    }

    if (best != null && await best.length() <= maxBytes) {
      return best;
    }

    throw Exception('Image size too large. Max 1MB');
  }
}
