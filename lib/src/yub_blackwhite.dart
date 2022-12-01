import 'yuv_color.dart';
import 'yuv_image.dart';

extension YuvBlackWhiteExt on YuvImage {
  YuvImage copyBlackWhite() => copy(this).toBlackAndWhite();

  YuvImage toBlackAndWhite() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setYuvColor(x, y, getYuvColor(x, y).blackwhite);
      }
    }
    return this;
  }
}
