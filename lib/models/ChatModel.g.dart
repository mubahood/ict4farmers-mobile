// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 55;

  @override
  ChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel()
      ..id = fields[0] as int
      ..created_at = fields[1] as String
      ..body = fields[2] as String
      ..sender = fields[3] as String
      ..receiver = fields[4] as String
      ..product_id = fields[5] as String
      ..thread = fields[6] as String
      ..received = fields[7] as bool
      ..seen = fields[8] as bool
      ..type = fields[9] as String
      ..receiver_pic = fields[10] as String
      ..contact = fields[11] as String
      ..gps = fields[12] as String
      ..file = fields[13] as String
      ..image = fields[14] as String
      ..audio = fields[15] as String
      ..receiver_name = fields[16] as String
      ..sender_name = fields[17] as String
      ..product_name = fields[18] as String
      ..product_pic = fields[19] as String
      ..unread_count = fields[20] as int
      ..sender_pic = fields[21] as String;
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.created_at)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.receiver)
      ..writeByte(5)
      ..write(obj.product_id)
      ..writeByte(6)
      ..write(obj.thread)
      ..writeByte(7)
      ..write(obj.received)
      ..writeByte(8)
      ..write(obj.seen)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.receiver_pic)
      ..writeByte(11)
      ..write(obj.contact)
      ..writeByte(12)
      ..write(obj.gps)
      ..writeByte(13)
      ..write(obj.file)
      ..writeByte(14)
      ..write(obj.image)
      ..writeByte(15)
      ..write(obj.audio)
      ..writeByte(16)
      ..write(obj.receiver_name)
      ..writeByte(17)
      ..write(obj.sender_name)
      ..writeByte(18)
      ..write(obj.product_name)
      ..writeByte(19)
      ..write(obj.product_pic)
      ..writeByte(20)
      ..write(obj.unread_count)
      ..writeByte(21)
      ..write(obj.sender_pic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
