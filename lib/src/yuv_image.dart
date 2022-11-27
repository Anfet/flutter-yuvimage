import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:yuvimage/src/yuv_planes.dart';

import 'yuv_color.dart';
import 'yuv_formats.dart';

abstract class YuvImage {
  YuvFormat get rawFormat;

  int get width;

  int get height;

  ///unmodifiable list of planes
  List<YuvPlane> get planes;

  Size get size => Size(width.toDouble(), height.toDouble());

  void setColor(int x, int y, YuvColor color);

  YuvColor getColor(int x, int y);

  Uint8List getBytes() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    return bytes;
  }

  YuvImage create(int width, int height);

  YuvImage copy(YuvImage other);

  List<Uint8List> copyRowBytes(int row, int start, int width);

  void putRowBytes(int row, int start, List<Uint8List> bytes);
}
