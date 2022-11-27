enum YuvFormat {
  ///Android: android.graphics.ImageFormat.YUV_420_888
  i420(rawValue: 35),

  ///iOS: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
  nv21(rawValue: 875704438),

  ///unsupported formats
  unsupported(rawValue: 0);

  final int rawValue;

  const YuvFormat({
    required this.rawValue,
  });
}
