import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';

part 'sexual_orientation_entity.g.dart';

@HiveType(typeId: sexualOrientationTypeId)
enum SexualOrientationEntity {
  @HiveField(0)
  straight,
  @HiveField(1)
  gay,
  @HiveField(2)
  asexual,
  @HiveField(3)
  bisexual,
  @HiveField(4)
  demiSexual,
  @HiveField(5)
  panSexual,
  @HiveField(6)
  queer,
  @HiveField(7)
  questioning,
}

SexualOrientation sexualOrientationEntityToModel(
    SexualOrientationEntity entity) {
  switch (entity) {
    case SexualOrientationEntity.straight:
      return SexualOrientation.straight;
    case SexualOrientationEntity.gay:
      return SexualOrientation.gay;
    case SexualOrientationEntity.asexual:
      return SexualOrientation.asexual;
    case SexualOrientationEntity.bisexual:
      return SexualOrientation.bisexual;
    case SexualOrientationEntity.demiSexual:
      return SexualOrientation.demiSexual;
    case SexualOrientationEntity.panSexual:
      return SexualOrientation.panSexual;
    case SexualOrientationEntity.queer:
      return SexualOrientation.queer;
    case SexualOrientationEntity.questioning:
      return SexualOrientation.questioning;
  }
}

SexualOrientationEntity sexualOrientationModelToEntity(
    SexualOrientation model) {
  switch (model) {
    case SexualOrientation.straight:
      return SexualOrientationEntity.straight;
    case SexualOrientation.gay:
      return SexualOrientationEntity.gay;
    case SexualOrientation.asexual:
      return SexualOrientationEntity.asexual;
    case SexualOrientation.bisexual:
      return SexualOrientationEntity.bisexual;
    case SexualOrientation.demiSexual:
      return SexualOrientationEntity.demiSexual;
    case SexualOrientation.panSexual:
      return SexualOrientationEntity.panSexual;
    case SexualOrientation.queer:
      return SexualOrientationEntity.queer;
    case SexualOrientation.questioning:
      return SexualOrientationEntity.questioning;
  }
}
