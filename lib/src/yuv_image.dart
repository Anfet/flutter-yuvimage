import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'yuv_color.dart';

class Yuv420ImagePlane {
  final int bytesPerPixel;
  late final int bytesPerRow;
  late final Uint8List bytes;
  final int? width;
  final int? height;

  Yuv420ImagePlane({
    required this.bytes,
    required this.bytesPerPixel,
    required this.bytesPerRow,
    this.width,
    this.height,
  });

  Yuv420ImagePlane.empty({required this.width, required this.height, required this.bytesPerPixel}) {
    bytes = Uint8List((width! * height!) ~/ bytesPerPixel);
    bytesPerRow = width!;
  }

  Yuv420ImagePlane.from(Yuv420ImagePlane other)
      : bytesPerPixel = other.bytesPerPixel,
        width = other.width,
        height = other.height {
    bytesPerRow = other.bytesPerRow;
    bytes = Uint8List.fromList(other.bytes);
  }
}

class Yuv420Image {
  final num width;
  final num height;
  late final List<Yuv420ImagePlane> planes;

  int get uvRowStride => planes[1].bytesPerRow;

  int get uvPixelStride => planes[1].bytesPerPixel;

  Yuv420ImagePlane get y => planes[0];

  Yuv420ImagePlane get u => planes[1];

  Yuv420ImagePlane get v => planes[2];

  Size get size => Size(width.toDouble(), height.toDouble());

  Yuv420Image(this.width, this.height, this.planes);

  Yuv420Image.from(Yuv420Image other)
      : width = other.width,
        height = other.height {
    var yplane = Yuv420ImagePlane.from(other.y);
    var uplane = Yuv420ImagePlane.from(other.u);
    var vplane = Yuv420ImagePlane.from(other.v);

    planes = [yplane, uplane, vplane];
  }

  Yuv420Image.createEmpty({required this.width, required this.height}) {
    var yplane = Yuv420ImagePlane.empty(width: width.toInt(), height: height.toInt(), bytesPerPixel: 1);
    var uplane = Yuv420ImagePlane.empty(width: width.toInt(), height: height.toInt(), bytesPerPixel: 2);
    var vplane = Yuv420ImagePlane.empty(width: width.toInt(), height: height.toInt(), bytesPerPixel: 2);
    planes = [yplane, uplane, vplane];
  }

  YuvColor getColor(num x, num y) {
    final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
    final int index = (y * width + x).toInt();

    final yp = planes[0].bytes[index];
    final up = planes[1].bytes[uvIndex];
    final vp = planes[2].bytes[uvIndex];
    return YuvColor.yuv(y: yp, u: up, v: vp);
  }

  void setColor(int x, int y, YuvColor color) {
    final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
    final int index = y * width.toInt() + x;

    planes[0].bytes[index] = color.y;
    planes[1].bytes[uvIndex] = color.u;
    planes[2].bytes[uvIndex] = color.v;
  }

  Yuv420Image crop(Rect rect) {
    num width = rect.right - rect.left;
    num height = rect.bottom - rect.top;
    final cropped = Yuv420Image.createEmpty(width: width, height: height);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        YuvColor color = getColor(x + rect.left, y + rect.top);
        cropped.setColor(x, y, color);
      }
    }

    return cropped;
  }

  Uint8List getBytes() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    return bytes;
  }
}
