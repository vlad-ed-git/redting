import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';

part 'ice_breaker_messages_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: iceBreakerMessagesTypeId)
class IceBreakerMessagesEntity implements IceBreakerMessages {
  @HiveField(0)
  @override
  List<String> messages;

  IceBreakerMessagesEntity({List<String>? messages})
      : messages = messages ?? [];

  @override
  factory IceBreakerMessagesEntity.fromJson(Map<String, dynamic> json) =>
      _$IceBreakerMessagesEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IceBreakerMessagesEntityToJson(this);

  @override
  IceBreakerMessages fromJson(Map<String, dynamic> json) {
    return IceBreakerMessagesEntity.fromJson(json);
  }
}
