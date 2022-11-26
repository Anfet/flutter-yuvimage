import 'yuv_image.dart';

extension Yuv420BlackWhiteExt on Yuv420Image {
  Yuv420Image copyBlackWhite() => Yuv420Image.from(this).toBlackAndWhite();

  Yuv420Image toBlackAndWhite() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setColor(x, y, getColor(x, y).bw);
      }
    }
    return this;
  }
}
