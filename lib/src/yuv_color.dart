import 'package:flutter/foundation.dart';

@immutable
class YuvColor {
  final int y;
  final int u;
  final int v;

  final int r;
  final int g;
  final int b;

  int get luminance => (0.299 * r + 0.587 * g + 0.114 * b).round();

  const YuvColor.black()
      : r = 0,
        g = 0,
        b = 0,
        y = 0,
        u = 0,
        v = 0;

  YuvColor.rgb({this.r = 0, this.g = 0, this.b = 0})
      : y = (0.257 * r + 0.504 * g + 0.098 * b + 16).toInt(),
        u = (-0.148 * r - 0.291 * g + 0.439 * b + 128).toInt(),
        v = (0.439 * r - 0.368 * g - 0.071 * b + 128).toInt();

  YuvColor.yuv({this.y = 0, this.u = 0, this.v = 0})
      : r = (y + v * 1436 / 1024 - 179).round().clamp(0, 255),
        g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round().clamp(0, 255),
        b = (y + u * 1814 / 1024 - 227).round().clamp(0, 255);

  YuvColor get negative => YuvColor.rgb(r: 255 - r, g: 255 - r, b: 255 - b);

  YuvColor get bw {
    var l = luminance;
    var rgb = l > 0x7F ? 0xff : 0x00;
    return YuvColor.rgb(r: rgb, g: rgb, b: rgb);
  }

  YuvColor get gray {
    final lum = luminance;
    return YuvColor.rgb(r: lum, g: lum, b: lum);
  }

  int get rgb => r << 16 | g << 8 | b;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YuvColor &&
          runtimeType == other.runtimeType &&
          y == other.y &&
          u == other.u &&
          v == other.v &&
          r == other.r &&
          g == other.g &&
          b == other.b;

  @override
  int get hashCode => y.hashCode ^ u.hashCode ^ v.hashCode ^ r.hashCode ^ g.hashCode ^ b.hashCode;

  @override
  String toString() {
    return 'YuvColor{y: $y, u: $u, v: $v, r: $r, g: $g, b: $b}';
  }
}
