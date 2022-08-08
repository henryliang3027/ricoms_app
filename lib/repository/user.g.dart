// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      ip: fields[1] as String,
      name: fields[2] as String,
      password: fields[3] as String,
      permission: fields[4] as String,
      email: fields[5] as String,
      mobile: fields[6] as String,
      tel: fields[7] as String,
      ext: fields[8] as String,
      bookmarks: (fields[9] as List).cast<int>(),
      isActivate: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.permission)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.mobile)
      ..writeByte(7)
      ..write(obj.tel)
      ..writeByte(8)
      ..write(obj.ext)
      ..writeByte(9)
      ..write(obj.bookmarks)
      ..writeByte(10)
      ..write(obj.isActivate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
