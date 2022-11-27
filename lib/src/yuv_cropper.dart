import 'dart:typed_data';
import 'dart:ui';

import 'yuv_image.dart';

extension YuvImageCropperExt on YuvImage {
  ///crop part of image to another, if rect is null, entire image is copied
  YuvImage crop([Rect? rect]) {
    final source = this;
    final left = (rect?.left ?? 0).toInt();
    final top = (rect?.top ?? 0).toInt();
    final width = ((rect?.right ?? this.width) - left).toInt();
    final height = ((rect?.bottom ?? this.height) - top).toInt();
    final target = source.create(width, height);
    for (int y = 0; y < target.height; y++) {
      List<Uint8List> bytes = source.copyRowBytes(y + top, left, target.width);
      target.putRowBytes(y, 0, bytes);
    }

    return target;
  }

  YuvImage copy() => crop();
}
