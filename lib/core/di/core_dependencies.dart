import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';

GetIt init() {
  final GetIt coreDiInstance = GetIt.instance;
//compressor
  coreDiInstance
      .registerLazySingleton<ImageCompressor>(() => ImageCompressorImpl());
  coreDiInstance
      .registerLazySingleton<VideoCompressor>(() => VideoCompressorImpl());

  return coreDiInstance;
}
