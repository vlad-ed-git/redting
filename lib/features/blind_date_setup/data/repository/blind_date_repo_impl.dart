import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/local/local_source.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/remote/remote_source.dart';
import 'package:redting/features/blind_date_setup/data/entities/blind_date_entity.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';
import 'package:redting/res/strings.dart';

const maxBlindDatesSetupsAllowed = 2;

class BlindDateRepoImpl implements BlindDateRepo {
  final AuthRepository _authRepository;
  final MatchingRepository _matchingRepository;
  final RemoteBlindDateSetupSource _remoteBlindDateSource;
  final LocalBlindDateSource _localBlindDateSource;
  BlindDateRepoImpl(this._authRepository, this._remoteBlindDateSource,
      this._localBlindDateSource, this._matchingRepository);

  @override
  Future<ServiceResult> canSetupBlindDate(AuthUser user) async {
    //check locally first
    bool hasReachedMax = await _localBlindDateSource.hasReachedMaxSetups();
    if (hasReachedMax) {
      return ServiceResult(data: !hasReachedMax);
    }

    //then check remote
    ServiceResult result =
        await _remoteBlindDateSource.getBlindSetupsDoneByUser(user);
    hasReachedMax = result.data is List &&
        (result.data as List).length >= maxBlindDatesSetupsAllowed;
    if (hasReachedMax) {
      await _localBlindDateSource.setHasReachedMaxSetups();
    }

    return ServiceResult(
        data: !hasReachedMax,
        errorOccurred: result.errorOccurred,
        errorMessage: result.errorMessage);
  }

  @override
  Future<ServiceResult> getAuthUserUseCase() {
    return _authRepository.getCachedAuthUser();
  }

  @override
  Future<ServiceResult> setupBlindDate(AuthUser authUser, String phoneNumber1,
      String phoneNumber2, String iceBreaker) async {
    String formattedNum1 = "+${phoneNumber1.trim()}".replaceAll("++", "+");
    String formattedNum2 = "+${phoneNumber2.trim()}".replaceAll("++", "+");

    String? errMsg;
    if (formattedNum1.length == 1 ||
        formattedNum2.length == 1 ||
        formattedNum1 == formattedNum2) {
      errMsg = phoneNumbersInvalid;
    }

    if (errMsg == null &&
        (formattedNum1[0] != "+" || formattedNum2[0] != "+")) {
      errMsg = phoneNumbersMissingCountryCodeErr;
    }

    if (errMsg == null &&
        (authUser.phoneNumber.trim() == formattedNum1 ||
            authUser.phoneNumber.trim() == formattedNum2)) {
      errMsg = cannotSetupBlindDateWithSelfErr;
    }

    if (errMsg == null && iceBreaker.trim().isEmpty) {
      errMsg = funIceBreakerMissingErr;
    }

    if (errMsg != null) {
      return ServiceResult(errorMessage: errMsg, errorOccurred: true);
    }

    final phoneToIds = await _remoteBlindDateSource.getIdsOfBlindDateParties(
        formattedNum1, formattedNum2);
    if (phoneToIds == null) {
      return ServiceResult(
          errorOccurred: true, errorMessage: blindDateSetupUnknownErr);
    }
    if (phoneToIds[formattedNum1] == null) {
      return ServiceResult(
          errorOccurred: true,
          errorMessage: "$formattedNum1 : $blindDateSetupNotSignedIn");
    }

    if (phoneToIds[formattedNum2] == null) {
      return ServiceResult(
          errorOccurred: true,
          errorMessage: "$formattedNum2 : $blindDateSetupNotSignedIn");
    }

    List<String> members = [
      phoneToIds[formattedNum1]!,
      phoneToIds[formattedNum2]!
    ];
    return _remoteBlindDateSource.setupBlindDate(BlindDateEntity(
        id: BlindDate.concatUser1User2IdsSortAndGetAsId(members),
        iceBreaker: iceBreaker,
        setupByUserId: authUser.userId,
        setupOn: DateTime.now(),
        members: members));
  }

  @override
  Future<IceBreakerMessages?> fetchIceBreakerMessages() async {
    return await _matchingRepository.getCachedIceBreakers();
  }

  @override
  Stream<List<OperationRealTimeResult>> listenToNewBlindDateSetups(
      String userId) {
    return _remoteBlindDateSource.listenToRecentBlindDates(userId);
  }

  @override
  Future<List<BlindDate>> loadOldBlindDateSetups(String userId) async {
    return await _remoteBlindDateSource.loadOldBlindDates(userId);
  }
}
