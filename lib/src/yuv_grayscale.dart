import 'package:yuvimage/src/yuv_color.dart';

import 'yuv_image.dart';

extension YuvGrayscaleExt on YuvImage {
  YuvImage copyGrayscale() => copy(this).grayscale();

  YuvImage grayscale() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setYuvColor(x, y, getYuvColor(x, y).gray);
      }
    }
    return this;
  }

  int get averageLuminance {
    var lumi = 0;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        lumi += getYuvColor(x, y).luminance;
      }
    }

    return lumi ~/ (width * height);
  }
}
