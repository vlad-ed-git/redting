import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class GetProfileFromRemoteUseCase {
  final ProfileRepository profileRepository;
  GetProfileFromRemoteUseCase({required this.profileRepository});

  Future<OperationResult> execute() async {
    return await profileRepository.loadUserProfileFromRemoteIfExists();
  }
}
