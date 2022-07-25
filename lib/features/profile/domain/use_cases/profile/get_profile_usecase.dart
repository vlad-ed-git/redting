import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class GetProfileUseCase {
  final ProfileRepository profileRepository;
  GetProfileUseCase({required this.profileRepository});

  Future<OperationResult> execute() async {
    return await profileRepository.getUserProfileFromRemote();
  }
}
