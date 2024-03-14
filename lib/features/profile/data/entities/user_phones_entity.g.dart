part of 'user_phones_entity.dart';

UserPhoneEntity _$UserPhoneEntityFromJson(Map json) => UserPhoneEntity(
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$UserPhoneEntityToJson(UserPhoneEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
    };
