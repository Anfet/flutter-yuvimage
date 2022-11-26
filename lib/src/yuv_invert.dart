import 'yuv_image.dart';

extension Yuv420InvertExt on Yuv420Image {
  Yuv420Image copyInvert() => Yuv420Image.from(this).invert();

  Yuv420Image invert() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setColor(x, y, getColor(x, y).negative);
      }
    }
    return this;
  }
}
