import 'package:redting/features/profile/domain/use_cases/profile/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/delete_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/update_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/delete_verification_video_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/upload_verification_video_usecase.dart';

class ProfileUseCases {
  final CreateProfileUseCase createProfileUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;
  final GenerateVideoVerificationCodeUseCase
      generateVideoVerificationCodeUseCase;
  final UploadVerificationVideoUseCase uploadVerificationVideoUseCase;
  final DeleteVerificationVideoUseCase deleteVerificationVideoUseCase;

  ProfileUseCases(
      {required this.createProfileUseCase,
      required this.getProfileUseCase,
      required this.updateProfileUseCase,
      required this.deleteProfileUseCase,
      required this.uploadProfilePhotoUseCase,
      required this.uploadVerificationVideoUseCase,
      required this.generateVideoVerificationCodeUseCase,
      required this.deleteVerificationVideoUseCase});
}
