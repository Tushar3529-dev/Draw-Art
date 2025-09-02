// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrawingAdapter extends TypeAdapter<Drawing> {
  @override
  final int typeId = 3;

  @override
  Drawing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drawing(
      name: fields[0] as String,
      strokes: (fields[1] as List).cast<Stroke>(),
      thumbnail: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, Drawing obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.strokes)
      ..writeByte(2)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
