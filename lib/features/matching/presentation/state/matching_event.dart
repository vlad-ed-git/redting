part of 'matching_bloc.dart';

@immutable
abstract class MatchingEvent {}

class InitializeEvent extends MatchingEvent {}

class LoadProfilesToMatchEvent extends MatchingEvent {
  final UserProfile profiles;
  LoadProfilesToMatchEvent(this.profiles);
}

class LikeUserEvent extends MatchingEvent {
  final String likedByUser;
  final UserProfile likedUserProfile;
  LikeUserEvent({required this.likedUserProfile, required this.likedByUser});
}

class SendUserFeedBackEvent extends MatchingEvent {
  final int rating;
  final String feedback;
  final String userId;
  SendUserFeedBackEvent(
      {required this.rating, required this.feedback, required this.userId});
}
