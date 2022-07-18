import 'package:redting/features/profile/domain/use_cases/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/delete_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/get_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/update_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/upload_verification_video_usecase.dart';

class ProfileUseCases {
  final CreateProfileUseCase createProfileUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;
  final GenerateVideoVerificationCodeUseCase
      generateVideoVerificationCodeUseCase;
  final UploadVerificationVideoUseCase uploadVerificationVideoUseCase;

  ProfileUseCases(
      {required this.createProfileUseCase,
      required this.getProfileUseCase,
      required this.updateProfileUseCase,
      required this.deleteProfileUseCase,
      required this.uploadProfilePhotoUseCase,
      required this.uploadVerificationVideoUseCase,
      required this.generateVideoVerificationCodeUseCase});
}
