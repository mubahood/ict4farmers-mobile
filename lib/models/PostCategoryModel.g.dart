// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostCategoryModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostCategoryModelAdapter extends TypeAdapter<PostCategoryModel> {
  @override
  final int typeId = 54;

  @override
  PostCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostCategoryModel()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..details = fields[2] as String
      ..thumnnail = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, PostCategoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.details)
      ..writeByte(3)
      ..write(obj.thumnnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
