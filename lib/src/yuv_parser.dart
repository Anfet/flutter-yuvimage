import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:yuvimage/src/images/yuv_i420_image.dart';
import 'package:yuvimage/src/images/yuv_nv21_image.dart';
import 'package:yuvimage/src/yuv_image.dart';
import 'package:yuvimage/src/yuv_planes.dart';

class YuvParser {
  YuvParser._();

  static YuvImage fromRaw(
    int width,
    int height,
    List<YuvPlaneParserData> planesData,
  ) {
    assert(width > 0 && height > 0);

    if (planesData.length == 3) {
      YuvPlane y = YuvPlane.fromBytes(
        planesData[0].bytes,
        planesData[0].bytesPerPixel ?? 1,
        planesData[0].bytesPerRow,
        name: 'y',
      );
      YuvPlane u = YuvPlane.fromBytes(
        planesData[1].bytes,
        planesData[1].bytesPerPixel ?? 2,
        planesData[1].bytesPerRow,
        name: 'u',
      );
      YuvPlane v = YuvPlane.fromBytes(
        planesData[2].bytes,
        planesData[2].bytesPerPixel ?? 2,
        planesData[2].bytesPerRow,
        name: 'v',
      );

      return Yuv420Image.fromBytes(width, height, [y, u, v]);
    }

    if (planesData.length == 2) {
      YuvPlane y = YuvPlane.fromBytes(
        planesData[0].bytes,
        planesData[0].bytesPerPixel ?? 1,
        planesData[0].bytesPerRow,
        name: 'y',
      );
      YuvPlane uv = YuvPlane.fromBytes(
        planesData[1].bytes,
        planesData[1].bytesPerPixel ?? 2,
        planesData[1].bytesPerRow,
        name: 'uv',
      );

      return YuvNV21Image.fromBytes(width, height, [y, uv]);
    }

    throw UnsupportedError("unsupported data");
  }
}

@immutable
class YuvPlaneParserData {
  final int bytesPerRow;
  final int? bytesPerPixel;
  final Uint8List bytes;

  YuvPlaneParserData(this.bytesPerRow, this.bytesPerPixel, this.bytes);
}
