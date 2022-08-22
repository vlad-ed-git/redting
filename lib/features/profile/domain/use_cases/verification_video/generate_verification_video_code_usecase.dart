import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class GenerateVideoVerificationCodeUseCase {
  final ProfileRepository profileRepository;
  GenerateVideoVerificationCodeUseCase({required this.profileRepository});

  Future<ServiceResult> execute() async {
    return await profileRepository.generateVerificationWord();
  }
}
