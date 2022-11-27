import 'yuv_image.dart';

extension YuvGrayscaleExt on YuvImage {
  YuvImage copyGrayscale() => copy(this).grayscale();

  YuvImage grayscale() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setColor(x, y, getColor(x, y).gray);
      }
    }
    return this;
  }

  int get averageLuminance {
    var lumi = 0;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        lumi += getColor(x, y).luminance;
      }
    }

    return lumi ~/ (width * height);
  }
}
