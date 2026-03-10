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
      tryingToQuitCount: fields[7] as String?,
      quitReasons: (fields[8] as List).cast<String>(),
      triggerMoment: fields[9] as String?,
      userId: fields[10] as String?,
      email: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.tryingToQuitCount)
      ..writeByte(8)
      ..write(obj.quitReasons)
      ..writeByte(9)
      ..write(obj.triggerMoment)
      ..writeByte(10)
      ..write(obj.userId)
      ..writeByte(11)
      ..write(obj.email);
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
