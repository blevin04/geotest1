// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachmentAdapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentsAdapter extends TypeAdapter<Attachments> {
  @override
  final int typeId = 0;

  @override
  Attachments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attachments(
      type: fields[0] as FileType,
      path: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Attachments obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
