// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_gender_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGenderEntityAdapter extends TypeAdapter<UserGenderEntity> {
  @override
  final int typeId = 2;

  @override
  UserGenderEntity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserGenderEntity.male;
      case 1:
        return UserGenderEntity.female;
      case 2:
        return UserGenderEntity.stated;
      default:
        return UserGenderEntity.male;
    }
  }

  @override
  void write(BinaryWriter writer, UserGenderEntity obj) {
    switch (obj) {
      case UserGenderEntity.male:
        writer.writeByte(0);
        break;
      case UserGenderEntity.female:
        writer.writeByte(1);
        break;
      case UserGenderEntity.stated:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGenderEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
