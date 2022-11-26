import 'yuv_image.dart';

extension Yuv420ImageRotateExt on Yuv420Image {
  Yuv420Image copyRotateOrthogonal(num degrees) {
    if (degrees < 0) {
      degrees = 360 - degrees.abs();
    }

    final num nangle = degrees % 360.0;
    if ((nangle % 90.0) != 0.0) {
      throw UnsupportedError("degrees must be divided by 90");
    }

    final wm1 = width - 1;
    final hm1 = height - 1;

    final iangle = nangle ~/ 90.0;
    switch (iangle) {
      case 1: // 90 deg.
        final dst = Yuv420Image.createEmpty(width: height, height: width);
        for (var y = 0; y < dst.height; ++y) {
          for (var x = 0; x < dst.width; ++x) {
            dst.setColor(x, y, getColor(y, hm1 - x));
          }
        }
        return dst;
      case 2: // 180 deg.
        final dst = Yuv420Image.createEmpty(width: width, height: height);
        for (var y = 0; y < dst.height; ++y) {
          for (var x = 0; x < dst.width; ++x) {
            dst.setColor(x, y, getColor(wm1 - x, hm1 - y));
          }
        }
        return dst;
      case 3: // 270 deg.
        final dst = Yuv420Image.createEmpty(width: height, height: width);
        for (var y = 0; y < dst.height; ++y) {
          for (var x = 0; x < dst.width; ++x) {
            dst.setColor(x, y, getColor(wm1 - y, x));
          }
        }
        return dst;
      default: // 0 deg.
        return Yuv420Image.from(this);
    }
  }
}
