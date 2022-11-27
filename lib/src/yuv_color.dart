import 'package:flutter/foundation.dart';

@immutable
class YuvColor {
  final int y;
  final int u;
  final int v;
  final int r;
  final int g;
  final int b;

  int get luminance => y;

  YuvColor get negative => YuvColor.rgb(255 - r, 255 - r, 255 - b);

  YuvColor get bw {
    var rgb = luminance > 0x7F ? 0xff : 0x00;
    return YuvColor.rgb(rgb, rgb, rgb);
  }

  YuvColor get gray => YuvColor.rgb(luminance, luminance, luminance);

  const YuvColor.black()
      : y = 0,
        u = 0,
        v = 0,
        r = 0,
        g = 0,
        b = 0;

  YuvColor.yuv(this.y, this.u, this.v)
      : r = (y + v * 1.402 - 179).round().clamp(0, 255),
        g = (y - u * 0.355 - v * 0.714 + 135).round().clamp(0, 255),
        b = (y + u * 1.771 - 227).round().clamp(0, 255);

  YuvColor.rgb(this.r, this.g, this.b)
      : y = (0.257 * r + 0.504 * g + 0.098 * b + 16).toInt(),
        u = (-0.148 * r - 0.291 * g + 0.439 * b + 128).toInt(),
        v = (0.439 * r - 0.368 * g - 0.071 * b + 128).toInt();
}
