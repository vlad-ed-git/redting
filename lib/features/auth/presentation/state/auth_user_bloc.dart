import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/utils/phone_verification_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:redting/res/strings.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final AuthUseCases authUseCases;

  AuthUserBloc({required this.authUseCases}) : super(InitialAuthUserState()) {
    on<LoadAuthUserEvent>(_onLoadAuthUserEvent);
    on<VerifyAuthUserEvent>(_verifyAuthUserEvent);
    on<SignInAuthUserEvent>(_signInAuthUserEvent);
    on<SwitchLoginModeEvent>(_switchLoginModeEvent);
    on<SendVerificationCodeAttemptedEvent>(_onSendVerificationAttemptEvent);
  }

  FutureOr<void> _onLoadAuthUserEvent(
      LoadAuthUserEvent event, Emitter<AuthUserState> emit) async {
    //loading
    emit(LoadingAuthState());

    ServiceResult result = await authUseCases.getAuthenticatedUser.execute();
    if (result.errorOccurred) {
      emit(ErrorLoadingAuthUserState());
    } else if (result.data is AuthUser) {
      emit(UserSignedInState(result.data as AuthUser));
    } else if (result.data == null) {
      emit(NoAuthUserFoundState());
    }
  }

  /// WHEN SENDING CODE WE PASS A CALLBACK
  /// AN EVENT [SendVerificationCodeAttemptedEvent] IS TRIGGERED IN THAT CALLBACK
  FutureOr<void> _verifyAuthUserEvent(
      VerifyAuthUserEvent event, Emitter<AuthUserState> emit) async {
    //loading
    emit(LoadingAuthState());
    authUseCases.sendVerificationCodeUseCase.execute(
      phone: event.phoneNumber,
      code: event.countryCode,
      resendToken: event.resendToken,
      callback: (PhoneVerificationResult result) async {
        add(SendVerificationCodeAttemptedEvent(result));
      },
    );
  }

  /// WHEN SENDING CODE WE PASS A CALLBACK
  /// THIS EVENT IS TRIGGERED IN THAT CALLBACK
  FutureOr<void> _onSendVerificationAttemptEvent(
      SendVerificationCodeAttemptedEvent event,
      Emitter<AuthUserState> emit) async {
    PhoneVerificationResult result = event.result;
    if (result.errorOccurred) {
      emit(VerificationFailedState(result.errMsg ?? unknownCodeSendingErr));
    }

    if (result.isAutoVerified) {
      ServiceResult signInResult = await authUseCases.signUserInUseCase
          .execute(credential: result.credential);

      if (signInResult.errorOccurred) {
        emit(SigningUserInFailedState(
            signInResult.errorMessage ?? unknownCodeSendingErr));
      } else {
        emit(UserSignedInState(signInResult.data as AuthUser));
      }
    }

    if (result.isCodeSent && result.verificationId != null) {
      emit(CodeSentToPhoneState(
          resendToken: result.resendToken,
          verificationId: result.verificationId!));
    }
  }

  FutureOr<void> _signInAuthUserEvent(
      SignInAuthUserEvent event, Emitter<AuthUserState> emit) async {
    //loading
    emit(LoadingAuthState());
    ServiceResult signInResult = await authUseCases.signUserInUseCase
        .execute(smsCode: event.smsCode, verificationId: event.verificationId);

    if (signInResult.errorOccurred) {
      emit(SigningUserInFailedState(
          signInResult.errorMessage ?? unknownCodeSendingErr));
    } else {
      emit(UserSignedInState(signInResult.data as AuthUser));
    }
  }

  _switchLoginModeEvent(
      SwitchLoginModeEvent event, Emitter<AuthUserState> emit) {
    //switch
    if (event.isInGetPhoneNotGetCodeMode) {
      emit(GetCodeState());
    } else {
      emit(GetPhoneState());
    }
  }
}
