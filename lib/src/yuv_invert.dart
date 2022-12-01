import 'package:yuvimage/src/yuv_color.dart';

import 'yuv_image.dart';

extension Yuv420InvertExt on YuvImage {
  YuvImage copyInvert() => copy(this).invert();

  YuvImage invert() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setYuvColor(x, y, getYuvColor(x, y).inverted);
      }
    }
    return this;
  }
}
