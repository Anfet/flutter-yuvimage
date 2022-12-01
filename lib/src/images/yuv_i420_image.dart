import 'dart:typed_data';
import 'dart:ui';

import '../yuv_color.dart';
import '../yuv_cropper.dart';
import '../yuv_formats.dart';
import '../yuv_image.dart';
import '../yuv_planes.dart';

class Yuv420Image extends YuvImage {
  @override
  final YuvFormat rawFormat = YuvFormat.i420;

  @override
  final int width;

  @override
  final int height;

  @override
  late final List<YuvPlane> planes;

  Size get size => Size(width.toDouble(), height.toDouble());

  Yuv420Image._(this.width, this.height, this.planes);

  Yuv420Image(this.width, this.height) {
    final yplane = YuvPlane(width, height, 1);
    final uvWidth = (width / 2).round();
    final uvHeight = (height / 2).round();
    final uplane = YuvPlane(uvWidth, uvHeight, 2);
    final vplane = YuvPlane(uvWidth, uvHeight, 2);
    planes = List.unmodifiable([yplane, uplane, vplane]);
  }

  Yuv420Image.fromBytes(this.width, this.height, this.planes);

  @override
  Yuv420Image create(int width, int height) => Yuv420Image(width, height);

  @override
  YuvColor getColor(int x, int y) {
    final yindex = (y * planes[0].rowStride) + (x * planes[0].pixelStride);
    final uvIndex = ((y ~/ 2) * planes[1].rowStride) + ((x ~/ 2) * planes[1].pixelStride);

    final yp = planes[0].bytes[yindex];
    final up = planes[1].bytes[uvIndex];
    final vp = planes[2].bytes[uvIndex];

    return YuvColor.yuv(yp, up, vp);
  }

  @override
  void setColor(int x, int y, YuvColor color) {
    final yindex = (y * planes[0].rowStride) + (x * planes[0].pixelStride);
    final uvIndex = ((y ~/ 2) * planes[1].rowStride) + ((x ~/ 2) * planes[1].pixelStride);

    planes[0].bytes[yindex] = color.y;
    planes[1].bytes[uvIndex] = color.u;
    planes[2].bytes[uvIndex] = color.v;
  }

  @override
  int getYuvColor(int x, int y) {
    final yindex = (y * planes[0].rowStride) + (x * planes[0].pixelStride);
    final uvIndex = ((y ~/ 2) * planes[1].rowStride) + ((x ~/ 2) * planes[1].pixelStride);

    final yp = planes[0].bytes[yindex];
    final up = planes[1].bytes[uvIndex];
    final vp = planes[2].bytes[uvIndex];

    return YuvColor.yuvToInt(yp, up, vp);
  }

  @override
  void setYuvColor(int x, int y, int color) {
    final yindex = (y * planes[0].rowStride) + (x * planes[0].pixelStride);
    final uvIndex = ((y ~/ 2) * planes[1].rowStride) + ((x ~/ 2) * planes[1].pixelStride);

    var yp =
    planes[0].bytes[yindex] = color.yr;
    planes[1].bytes[uvIndex] = color.ug;
    planes[2].bytes[uvIndex] = color.vb;
  }

  @override
  YuvImage copy(YuvImage other) {
    if (other.rawFormat == rawFormat) {
      return Yuv420Image._(width, height, List.of(planes.map((plane) => plane.copy())));
    } else {
      return YuvImageCropperExt(this).copy();
    }
  }

  @override
  List<Uint8List> copyRowBytes(int row, int start, int width) {
    var y = planes[0].copyBytes(row, start, width);
    var u = planes[1].copyBytes(row ~/ 2, start ~/ 2, width ~/ 2);
    var v = planes[2].copyBytes(row ~/ 2, start ~/ 2, width ~/ 2);
    return [y, u, v];
  }

  @override
  void putRowBytes(int row, int start, List<Uint8List> bytes) {
    assert(bytes.length == 3);
    planes[0].pasteBytes(row, start, bytes[0]);
    planes[1].pasteBytes(row ~/ 2, start ~/ 2, bytes[1]);
    planes[2].pasteBytes(row ~/ 2, start ~/ 2, bytes[2]);
  }


}
