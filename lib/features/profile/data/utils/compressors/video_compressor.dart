import 'dart:io';

import 'package:video_compress/video_compress.dart';

abstract class VideoCompressor {
  Future<File> compressVideoReturnCompressedOrOg(File file);
  dispose();
}

class VideoCompressorImpl implements VideoCompressor {
  @override
  Future<File> compressVideoReturnCompressedOrOg(File file) async {
    try {
      MediaInfo? info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.Res1280x720Quality,
        includeAudio: true,
      );
      if (info != null && info.path != null) {
        return File(info.path!);
      } else {
        return file;
      }
    } catch (_) {
      VideoCompress.cancelCompression();
      return file;
    }
  }

  @override
  dispose() async {
    await VideoCompress.deleteAllCache();
  }
}
