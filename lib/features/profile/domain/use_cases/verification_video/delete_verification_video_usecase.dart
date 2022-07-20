import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class DeleteVerificationVideoUseCase {
  final ProfileRepository profileRepository;
  DeleteVerificationVideoUseCase(this.profileRepository);

  Future<OperationResult> execute() async {
    return await profileRepository.deleteVerificationVideo();
  }
}
