part of 'matching_bloc.dart';

@immutable
abstract class MatchingEvent {}

class InitializeEvent extends MatchingEvent {}

class LoadProfilesEvent extends MatchingEvent {
  final MatchingUserProfileWrapper _userProfileWrapper;
  LoadProfilesEvent(this._userProfileWrapper);
}

class LikeUserEvent extends MatchingEvent {
  final String likedByUser;
  final MatchingUserProfileWrapper likedUserProfile;
  LikeUserEvent({required this.likedUserProfile, required this.likedByUser});
}

class SendUserFeedBackEvent extends MatchingEvent {
  final int rating;
  final String feedback;
  final String userId;
  SendUserFeedBackEvent(
      {required this.rating, required this.feedback, required this.userId});
}
