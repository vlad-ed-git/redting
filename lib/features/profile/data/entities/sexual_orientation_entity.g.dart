// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sexual_orientation_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SexualOrientationEntityAdapter
    extends TypeAdapter<SexualOrientationEntity> {
  @override
  final int typeId = 5;

  @override
  SexualOrientationEntity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SexualOrientationEntity.straight;
      case 1:
        return SexualOrientationEntity.gay;
      case 2:
        return SexualOrientationEntity.asexual;
      case 3:
        return SexualOrientationEntity.bisexual;
      case 4:
        return SexualOrientationEntity.demiSexual;
      case 5:
        return SexualOrientationEntity.panSexual;
      case 6:
        return SexualOrientationEntity.queer;
      case 7:
        return SexualOrientationEntity.questioning;
      default:
        return SexualOrientationEntity.straight;
    }
  }

  @override
  void write(BinaryWriter writer, SexualOrientationEntity obj) {
    switch (obj) {
      case SexualOrientationEntity.straight:
        writer.writeByte(0);
        break;
      case SexualOrientationEntity.gay:
        writer.writeByte(1);
        break;
      case SexualOrientationEntity.asexual:
        writer.writeByte(2);
        break;
      case SexualOrientationEntity.bisexual:
        writer.writeByte(3);
        break;
      case SexualOrientationEntity.demiSexual:
        writer.writeByte(4);
        break;
      case SexualOrientationEntity.panSexual:
        writer.writeByte(5);
        break;
      case SexualOrientationEntity.queer:
        writer.writeByte(6);
        break;
      case SexualOrientationEntity.questioning:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SexualOrientationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
