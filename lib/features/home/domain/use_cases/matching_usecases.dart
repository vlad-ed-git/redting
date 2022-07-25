import 'package:redting/features/home/domain/use_cases/fetch_profiles_to_match.dart';
import 'package:redting/features/home/domain/use_cases/initialize_usecase.dart';
import 'package:redting/features/home/domain/use_cases/like_user_usecase.dart';
import 'package:redting/features/home/domain/use_cases/pass_on_user_usecase.dart';

class MatchingUseCases {
  final InitializeUseCase initializeUserProfilesUseCase;
  final FetchProfilesToMatch fetchProfilesToMatch;
  final LikeUserUseCase likeUserUseCase;
  final PassOnUserUseCase passOnUserUseCase;

  MatchingUseCases(
      {required this.initializeUserProfilesUseCase,
      required this.fetchProfilesToMatch,
      required this.likeUserUseCase,
      required this.passOnUserUseCase});
}
