// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 30;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel()
      ..id = fields[0] as int
      ..created_at = fields[1] as String
      ..name = fields[2] as String
      ..category_id = fields[3] as String
      ..user_id = fields[4] as String
      ..country_id = fields[5] as String
      ..city_id = fields[6] as String
      ..price = fields[7] as String
      ..slug = fields[8] as String
      ..status = fields[9] as String
      ..description = fields[10] as String
      ..quantity = fields[11] as String
      ..images = fields[12] as String
      ..thumbnail = fields[13] as String
      ..attributes = fields[14] as String
      ..sub_category_id = fields[15] as String
      ..fixed_price = fields[16] as String;
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.created_at)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.category_id)
      ..writeByte(4)
      ..write(obj.user_id)
      ..writeByte(5)
      ..write(obj.country_id)
      ..writeByte(6)
      ..write(obj.city_id)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.slug)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.quantity)
      ..writeByte(12)
      ..write(obj.images)
      ..writeByte(13)
      ..write(obj.thumbnail)
      ..writeByte(14)
      ..write(obj.attributes)
      ..writeByte(15)
      ..write(obj.sub_category_id)
      ..writeByte(16)
      ..write(obj.fixed_price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
