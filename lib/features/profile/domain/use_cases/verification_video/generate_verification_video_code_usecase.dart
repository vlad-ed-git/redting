import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class GenerateVideoVerificationCodeUseCase {
  final ProfileRepository profileRepository;
  GenerateVideoVerificationCodeUseCase({required this.profileRepository});

  Future<OperationResult> execute() async {
    return await profileRepository.generateVerificationWord();
  }
}
