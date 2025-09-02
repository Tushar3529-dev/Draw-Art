import 'dart:typed_data';
import 'package:drawing_app/feature/draw/model/stroke.dart';
import 'package:hive/hive.dart';

part 'drawing.g.dart';

@HiveType(typeId: 3)
class Drawing extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Stroke> strokes;

  @HiveField(2)
  Uint8List thumbnail;

  Drawing({
    required this.name,
    required this.strokes,
    required this.thumbnail,
  });
}
