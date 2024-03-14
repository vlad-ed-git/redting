import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

part 'user_gender_entity.g.dart';

@HiveType(typeId: userGenderTypeId)
enum UserGenderEntity {
  @HiveField(0)
  male,
  @HiveField(1)
  female,
  @HiveField(2)
  stated
}

UserGender genderEntityToGenderModel(UserGenderEntity genderEntity) {
  switch (genderEntity) {
    case UserGenderEntity.male:
      return UserGender.male;
    case UserGenderEntity.female:
      return UserGender.female;
    case UserGenderEntity.stated:
      return UserGender.stated;
  }
}

UserGenderEntity genderModelToGenderEntity(UserGender gender) {
  switch (gender) {
    case UserGender.male:
      return UserGenderEntity.male;
    case UserGender.female:
      return UserGenderEntity.female;
    case UserGender.stated:
      return UserGenderEntity.stated;
  }
}
