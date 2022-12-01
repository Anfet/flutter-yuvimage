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

  YuvColor get inverted => YuvColor.rgb(255 - r, 255 - g, 255 - b);

  YuvColor get bw {
    var rgb = luminance > 0x7F ? 0xff : 0x00;
    return YuvColor.rgb(rgb, rgb, rgb);
  }

  YuvColor get gray => YuvColor.rgb(luminance, luminance, luminance);

  int get rgb => rgbToInt(r, g, b);

  int get yuv => yuvToInt(y, u, v);

  const YuvColor.black()
      : y = 0,
        u = 0,
        v = 0,
        r = 0,
        g = 0,
        b = 0;

  YuvColor.yuv(this.y, this.u, this.v)
      : r = (1.164 * (y - 16) + 1.596 * (v - 128)).round().clamp(0, 255),
        g = (1.164 * (y - 16) - 0.392 * (u - 128) - 0.813 * (v - 128)).round().clamp(0, 255),
        b = (1.164 * (y - 16) + 2.017 * (u - 128)).round().clamp(0, 255);

  YuvColor.rgb(this.r, this.g, this.b)
      : y = (0.257 * r + 0.504 * g + 0.098 * b + 16).toInt(),
        u = (-0.148 * r - 0.291 * g + 0.439 * b + 128).toInt(),
        v = (0.439 * r - 0.368 * g - 0.071 * b + 128).toInt();

  factory YuvColor.fromRgb(int rgb) => YuvColor.rgb(rgb.yr, rgb.ug, rgb.vb);

  factory YuvColor.fromYuv(int yuv) => YuvColor.yuv(yuv.yr, yuv.ug, yuv.vb);

  static int yuvToInt(int y, int u, int v) => (v & 0xff) << 16 | (u & 0xff) << 8 | (y & 0xff);

  static int rgbToInt(int r, int g, int b) => (b & 0xff) << 16 | (g & 0xff) << 8 | (r & 0xff);
}

extension YuvIntExt on int {
  int get inverted => (~this) & 0x00ffffff;

  int get blackwhite => yr > 0x7e ? 0x007f7fff : 0x007f7f00;

  int get luminance => yr;

  int get gray => (0x7f << 16) | (0x7f << 8) | luminance;

  int yuvToRgb() {
    var r = (1.164 * (yr - 16) + 1.596 * (vb - 128)).round().clamp(0, 255);
    var g = (1.164 * (yr - 16) - 0.392 * (ug - 128) - 0.813 * (vb - 128)).round().clamp(0, 255);
    var b = (1.164 * (yr - 16) + 2.017 * (ug - 128)).round().clamp(0, 255);
    return YuvColor.rgbToInt(r, g, b);
  }

  int rgbToYuv() {
    var y = (0.257 * yr + 0.504 * ug + 0.098 * vb + 16).toInt();
    var u = (-0.148 * yr - 0.291 * ug + 0.439 * vb + 128).toInt();
    var v = (0.439 * yr - 0.368 * ug - 0.071 * vb + 128).toInt();
    return YuvColor.yuvToInt(y, u, v);
  }

  int get yr => (this & 0x000000ff);

  int get ug => (this & 0x0000ff00) >> 8;

  int get vb => (this & 0x00ff0000) >> 16;
}
