import 'dart:ui';

import 'yuv_color.dart';
import 'yuv_image.dart';

extension Yuv420CropperExt on Yuv420Image {
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
}
