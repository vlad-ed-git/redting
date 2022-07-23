import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class ImageCompressor {
  Future<File> compressImageAndGetCompressedOrOg(File file);
}

class ImageCompressorImpl implements ImageCompressor {
  @override
  Future<File> compressImageAndGetCompressedOrOg(File file) async {
    try {
      final targetPath = p.join((await getTemporaryDirectory()).path,
          '${DateTime.now()}.${p.extension(file.path)}');
      var compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        autoCorrectionAngle: true,
        quality: 70,
        numberOfRetries: 1,
        minHeight: 720,
        minWidth: 720,
      );

      return compressedFile ?? file;
    } catch (e) {
      return file;
    }
  }
}
