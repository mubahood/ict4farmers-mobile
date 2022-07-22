// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DynamicTable.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicTableAdapter extends TypeAdapter<DynamicTable> {
  @override
  final int typeId = 60;

  @override
  DynamicTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicTable()
      ..id = fields[0] as int
      ..own_id = fields[1] as int
      ..data_type = fields[3] as String
      ..data = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, DynamicTable obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.own_id)
      ..writeByte(3)
      ..write(obj.data_type)
      ..writeByte(4)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
