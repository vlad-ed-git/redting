import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';

GetIt init() {
  final GetIt diInstance = GetIt.instance;
//compressor
  diInstance
      .registerLazySingleton<ImageCompressor>(() => ImageCompressorImpl());
  diInstance
      .registerLazySingleton<VideoCompressor>(() => VideoCompressorImpl());

  return diInstance;
}
