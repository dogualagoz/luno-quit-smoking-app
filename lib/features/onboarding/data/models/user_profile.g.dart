// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      nickname: fields[0] as String,
      dailyCigarettes: fields[1] as int,
      smokingYears: fields[2] as int,
      packPrice: fields[3] as double,
      cigarettesPerPack: fields[4] as int,
      quitDate: fields[5] as DateTime?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nickname)
      ..writeByte(1)
      ..write(obj.dailyCigarettes)
      ..writeByte(2)
      ..write(obj.smokingYears)
      ..writeByte(3)
      ..write(obj.packPrice)
      ..writeByte(4)
      ..write(obj.cigarettesPerPack)
      ..writeByte(5)
      ..write(obj.quitDate)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
