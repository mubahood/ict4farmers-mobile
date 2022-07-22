// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TestModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestModelsAdapter extends TypeAdapter<TestModels> {
  @override
  final int typeId = 30;

  @override
  TestModels read(BinaryReader reader) {
    return TestModels();
  }

  @override
  void write(BinaryWriter writer, TestModels obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
