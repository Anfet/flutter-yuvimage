import 'dart:typed_data';
import 'dart:ui';

import '../yuv_color.dart';
import '../yuv_cropper.dart';
import '../yuv_formats.dart';
import '../yuv_image.dart';
import '../yuv_planes.dart';

class YuvNV21Image extends YuvImage {
  @override
  final YuvFormat rawFormat = YuvFormat.nv21;

  @override
  final int width;

  @override
  final int height;

  @override
  late final List<YuvPlane> planes;

  Size get size => Size(width.toDouble(), height.toDouble());

  YuvNV21Image.fromBytes(this.width, this.height, this.planes);

  YuvNV21Image(this.width, this.height) {
    final yplane = YuvPlane(width, height, 1);
    final uvWidth = (width / 2).round();
    final uvHeight = (height / 2).round();
    final uvplane = YuvPlane(uvWidth, uvHeight, 2);
    planes = List.unmodifiable([yplane, uvplane]);
  }

  YuvNV21Image._(this.width, this.height, this.planes);

  @override
  YuvNV21Image create(int width, int height) => YuvNV21Image(width, height);

  @override
  YuvColor getColor(int x, int y) {
    final int index = y * planes[0].rowStride + x;
    final int vIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride;
    final int uIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride + 1;

    final yp = planes[0].bytes[index];
    final up = planes[1].bytes[uIndex];
    final vp = planes[1].bytes[vIndex];
    return YuvColor.yuv(yp, up, vp);
  }

  @override
  void setColor(int x, int y, YuvColor color) {
    final int index = y * planes[0].rowStride + x;
    final int vIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride;
    final int uIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride + 1;

    planes[0].bytes[index] = color.y;
    planes[1].bytes[uIndex] = color.u;
    planes[1].bytes[vIndex] = color.v;
  }

  @override
  YuvImage copy(YuvImage other) {
    if (other.rawFormat == rawFormat) {
      return YuvNV21Image._(width, height, List.of(planes.map((plane) => plane.copy())));
    } else {
      return YuvImageCropperExt(this).copy();
    }
  }

  @override
  List<Uint8List> copyRowBytes(int row, int start, int width) {
    var y = planes[0].copyBytes(row, start, width);
    var uv = planes[1].copyBytes(row ~/ 2, start ~/ 2, width ~/ 2);
    return [y, uv];
  }

  @override
  void putRowBytes(int row, int start, List<Uint8List> bytes) {
    assert(bytes.length == 2);
    planes[0].pasteBytes(row, start, bytes[0]);
    planes[1].pasteBytes(row ~/ 2, start ~/ 2, bytes[1]);
  }

  @override
  int getYuvColor(int x, int y) {
    final int index = y * planes[0].rowStride + x;
    final int vIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride;
    final int uIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride + 1;

    final yp = planes[0].bytes[index];
    final up = planes[1].bytes[uIndex];
    final vp = planes[1].bytes[vIndex];
    return YuvColor.yuvToInt(yp, up, vp);
  }

  @override
  void setYuvColor(int x, int y, int color) {
    final int index = y * planes[0].rowStride + x;
    final int vIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride;
    final int uIndex = (planes[1].rowStride * (y ~/ 2)) + (x ~/ 2) * planes[1].pixelStride + 1;

    planes[0].bytes[index] = color.yr;
    planes[1].bytes[uIndex] = color.ug;
    planes[1].bytes[vIndex] = color.vb;
  }
}
