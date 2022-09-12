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
      id: fields[0] == null ? '-' : fields[0] as String,
      ip: fields[1] == null ? '-' : fields[1] as String,
      name: fields[2] == null ? '-' : fields[2] as String,
      password: fields[3] == null ? '-' : fields[3] as String,
      permission: fields[4] == null ? '-' : fields[4] as String,
      email: fields[5] == null ? '-' : fields[5] as String,
      mobile: fields[6] == null ? '-' : fields[6] as String,
      tel: fields[7] == null ? '-' : fields[7] as String,
      ext: fields[8] == null ? '-' : fields[8] as String,
      bookmarks:
          fields[9] == null ? [] : (fields[9] as List).cast<DeviceMeta>(),
      isActivate: fields[10] == null ? false : fields[10] as bool,
      account: fields[11] == null ? '-' : fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.isActivate)
      ..writeByte(11)
      ..write(obj.account);
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

class DeviceMetaAdapter extends TypeAdapter<DeviceMeta> {
  @override
  final int typeId = 2;

  @override
  DeviceMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceMeta(
      id: fields[0] == null ? -1 : fields[0] as int,
      name: fields[1] == null ? '-' : fields[1] as String,
      type: fields[2] == null ? -1 : fields[2] as int,
      ip: fields[3] == null ? '-' : fields[3] as String,
      shelf: fields[4] == null ? -1 : fields[4] as int,
      slot: fields[5] == null ? -1 : fields[5] as int,
      path: fields[6] == null ? [] : (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeviceMeta obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.ip)
      ..writeByte(4)
      ..write(obj.shelf)
      ..writeByte(5)
      ..write(obj.slot)
      ..writeByte(6)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
