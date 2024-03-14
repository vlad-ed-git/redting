import 'package:redting/features/profile/domain/use_cases/profile/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_cached_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_profile_from_remote_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/set_dating_info_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/update_user_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/add_dating_pic.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/delete_verification_video_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/upload_verification_video_usecase.dart';

class ProfileUseCases {
  final CreateProfileUseCase createProfileUseCase;
  final GetProfileFromRemoteUseCase getProfileFromRemoteUseCase;
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;
  final GenerateVideoVerificationCodeUseCase
      generateVideoVerificationCodeUseCase;
  final UploadVerificationVideoUseCase uploadVerificationVideoUseCase;
  final DeleteVerificationVideoUseCase deleteVerificationVideoUseCase;
  final GetCachedProfileUseCase getCachedProfileUseCase;
  final AddDatingPicUseCase addDatingPicUseCase;
  final SetDatingInfoUseCase setDatingInfoUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  ProfileUseCases(
      {required this.createProfileUseCase,
      required this.getProfileFromRemoteUseCase,
      required this.uploadProfilePhotoUseCase,
      required this.uploadVerificationVideoUseCase,
      required this.generateVideoVerificationCodeUseCase,
      required this.deleteVerificationVideoUseCase,
      required this.getCachedProfileUseCase,
      required this.addDatingPicUseCase,
      required this.setDatingInfoUseCase,
      required this.updateUserProfileUseCase});
}
