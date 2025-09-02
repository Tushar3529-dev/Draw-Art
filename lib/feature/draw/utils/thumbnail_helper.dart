
import 'dart:typed_data';
import 'dart:ui';
import 'package:drawing_app/feature/draw/model/stroke.dart';
import 'package:flutter/material.dart';

Future<Uint8List> generateThumbnail(
    List<Stroke> strokes, double width, double height) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

  canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.fill);

  for (final stroke in strokes) {
    final paint = Paint()
      ..color = stroke.strokeColor
      ..strokeWidth = stroke.brushSize
      ..strokeCap = StrokeCap.round;

    final points = stroke.offsetPoints;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await img.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
