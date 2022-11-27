import 'yuv_image.dart';

extension Yuv420InvertExt on YuvImage {
  YuvImage copyInvert() => copy(this).invert();

  YuvImage invert() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setColor(x, y, getColor(x, y).negative);
      }
    }
    return this;
  }
}
