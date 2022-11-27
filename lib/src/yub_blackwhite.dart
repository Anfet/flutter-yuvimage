import 'yuv_image.dart';

extension YuvBlackWhiteExt on YuvImage {
  YuvImage copyBlackWhite() => copy(this).toBlackAndWhite();

  YuvImage toBlackAndWhite() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setColor(x, y, getColor(x, y).bw);
      }
    }
    return this;
  }
}
