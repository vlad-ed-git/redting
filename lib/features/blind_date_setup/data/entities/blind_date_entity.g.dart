// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_date_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindDateEntity _$BlindDateEntityFromJson(Map json) => BlindDateEntity(
      id: json['id'] as String,
      iceBreaker: json['iceBreaker'] as String,
      setupByUserId: json['setupByUserId'] as String,
      setupOn:
          const TimestampConverter().fromJson(json['setupOn'] as Timestamp),
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BlindDateEntityToJson(BlindDateEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iceBreaker': instance.iceBreaker,
      'setupByUserId': instance.setupByUserId,
      'setupOn': const TimestampConverter().toJson(instance.setupOn),
      'members': instance.members,
    };
