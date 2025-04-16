// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locAlarmAdapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class locAlarmNAdapter extends TypeAdapter<locAlarmN> {
  @override
  final int typeId = 1;

  @override
  locAlarmN read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return locAlarmN(
      attachments: (fields[5] as List).cast<dynamic>(),
      id: fields[0] as String,
      isCircle: fields[2] as bool,
      message: fields[4] as String,
      points: (fields[1] as List).cast<dynamic>(),
      radius: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, locAlarmN obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.isCircle)
      ..writeByte(3)
      ..write(obj.radius)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is locAlarmNAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
