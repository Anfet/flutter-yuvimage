import 'package:flutter/foundation.dart';

@immutable
abstract class YuvColor {
  int get y;

  int get u;

  int get v;

  int get r;

  int get g;

  int get b;

  int get luminance => (0.299 * r + 0.587 * g + 0.114 * b).round();

  YuvColor get negative => YuvColorRgb(255 - r, 255 - r, 255 - b);

  YuvColor get bw {
    var l = luminance;
    var rgb = l > 0x7F ? 0xff : 0x00;
    return YuvColorRgb(rgb, rgb, rgb);
  }

  YuvColor get gray {
    final lum = luminance;
    return YuvColorRgb(lum, lum, lum);
  }

  factory YuvColor.black() => const YuvColorRgb.black();

  factory YuvColor.yuv(int y, int u, int v) => YuvColorYuv(y, u, v);

  factory YuvColor.rgb(int r, int g, int b) => YuvColorRgb(r, g, b);

  const YuvColor._();
}

class YuvColorYuv extends YuvColor {
  final int y;
  final int u;
  final int v;

  int get r => (y + v * 1436 / 1024 - 179).round().clamp(0, 255);

  int get g => (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round().clamp(0, 255);

  int get b => (y + u * 1814 / 1024 - 227).round().clamp(0, 255);

  const YuvColorYuv.black()
      : y = 0,
        u = 0,
        v = 0,
        super._();

  const YuvColorYuv(this.y, this.u, this.v) : super._();
}

@immutable
class YuvColorRgb extends YuvColor {
  int get y => (0.257 * r + 0.504 * g + 0.098 * b + 16).toInt();

  int get u => (-0.148 * r - 0.291 * g + 0.439 * b + 128).toInt();

  int get v => (0.439 * r - 0.368 * g - 0.071 * b + 128).toInt();

  final int r;
  final int g;
  final int b;

  const YuvColorRgb(this.r, this.g, this.b) : super._();

  const YuvColorRgb.black()
      : r = 0,
        g = 0,
        b = 0,
        super._();
}
