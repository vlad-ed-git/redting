import 'package:redting/features/dating_profile/domain/use_cases/crud/create_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/crud/get_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/crud/update_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/photos/add_photo_usecase.dart';

class DatingProfileUseCases {
  final CreateDatingProfileUseCase createDatingProfileUseCase;
  final GetDatingProfileUseCase getDatingProfileUseCase;
  final AddPhotoUseCase addPhotoUseCase;
  final UpdateDatingProfileUseCase updateDatingProfileUseCase;
  DatingProfileUseCases({
    required this.createDatingProfileUseCase,
    required this.getDatingProfileUseCase,
    required this.addPhotoUseCase,
    required this.updateDatingProfileUseCase,
  });
}
