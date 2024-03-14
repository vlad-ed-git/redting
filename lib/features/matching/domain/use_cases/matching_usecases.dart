import 'package:redting/features/matching/domain/use_cases/fetch_profiles_to_match.dart';
import 'package:redting/features/matching/domain/use_cases/get_this_usersinfo_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/like_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/listen_to_matches_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/pass_on_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/send_daily_feedback.dart';
import 'package:redting/features/matching/domain/use_cases/sync_with_remote.dart';

class MatchingUseCases {
  final SyncWithRemote syncWithRemote;
  final FetchProfilesToMatch fetchProfilesToMatch;
  final LikeUserUseCase likeUserUseCase;
  final PassOnUserUseCase passOnUserUseCase;
  final SendUserDailyFeedback sendUserDailyFeedback;
  final ListenToMatchUseCase listenToMatchUseCase;
  final GetThisUsersInfoUseCase getThisUsersInfoUseCase;
  MatchingUseCases(
      {required this.syncWithRemote,
      required this.fetchProfilesToMatch,
      required this.likeUserUseCase,
      required this.passOnUserUseCase,
      required this.sendUserDailyFeedback,
      required this.listenToMatchUseCase,
      required this.getThisUsersInfoUseCase});
}
