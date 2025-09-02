import 'dart:ui';
import 'package:hive/hive.dart';
export 'dart:ui' show Offset;

part 'offset.g.dart';

@HiveType(typeId: 2)
class OffsetCustom extends HiveObject {
  @HiveField(0)
  final double dx;

  @HiveField(1)
  final double dy;

  OffsetCustom(this.dx, this.dy);

  Offset toOffset() => Offset(dx, dy);

  factory OffsetCustom.fromOffset(Offset offset) {
    return OffsetCustom(offset.dx, offset.dy);
  }

  OffsetCustom copyWith({double? dx, double? dy}) {
    return OffsetCustom(dx ?? this.dx, dy ?? this.dy);
  }
}
