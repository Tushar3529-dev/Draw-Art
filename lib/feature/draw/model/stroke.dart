import 'package:drawing_app/feature/draw/model/offset.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'stroke.g.dart';

@HiveType(typeId: 1)
class Stroke extends HiveObject {
  @HiveField(0)
  final List<OffsetCustom> points;

  @HiveField(1)
  final int color;

  @HiveField(2)
  final double brushSize;

  Stroke({
    required this.points,
    required this.color,
    required this.brushSize,
  });

  Color get strokeColor => Color(color);

  List<Offset> get offsetPoints => points.map((e) => e.toOffset()).toList();

  factory Stroke.fromOffsetList({
    required List<Offset> points,
    required Color color,
    required double brushSize,
  }) {
    return Stroke(
      points: List.unmodifiable(
        points.map((e) => OffsetCustom.fromOffset(e)),
      ),
      color: color.value,
      brushSize: brushSize,
    );
  }

  Stroke copyWith({
    List<OffsetCustom>? points,
    int? color,
    double? brushSize,
  }) {
    return Stroke(
      points: points ?? this.points,
      color: color ?? this.color,
      brushSize: brushSize ?? this.brushSize,
    );
  }
}
