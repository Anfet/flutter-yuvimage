<!--
YuvImage
-->

Small dart only library for manipulating yuv images. Usually coming from CameraImage. Supports i420 for android and nv21 for ios

## Features

Allows you to receive a CameraImage, convert it to YuvImage and do some manipulation, like, crop, rotate, get, set colors and feed it forward.
Since it's pure dart, code is slow for streaming.

## Usage

```dart
const _shift = (0xFF << 24);

extension Yuv420ImageExt on YuvImage {
  imglib.Image toBitmap() {
    var img = imglib.Image(width.toInt(), height.toInt());

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        var color = getColor(x, y);
        final int index = y * width.toInt() + x;
        img.data[index] = _shift | (color.b << 16) | (color.g << 8) | color.r;
      }
    }

    return img;
  }

  InputImage toInputImage(int sensorOrientation) {
    final bytes = getBytes();
    final InputImageRotation imageRotation = InputImageRotationValue.fromRawValue(sensorOrientation)!;
    final inputImageData = InputImageData(
      size: size,
      imageRotation: imageRotation,
      inputImageFormat: InputImageFormat.yuv420,
      planeData: planes
          .map(
            (yuvPlane) => InputImagePlaneMetadata(
              bytesPerRow: yuvPlane.rowStride,
              height: yuvPlane.height,
              width: yuvPlane.width,
            ),
          )
          .toList(growable: false),
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return inputImage;
  }
}

extension Camera2YuvImageExt on CameraImage {
  YuvImage toYuvImage() {
    final image = YuvParser.fromRaw(
      width,
      height,
      planes.map((data) => YuvPlaneParserData(data.bytesPerRow, data.bytesPerPixel, data.bytes)).toList(),
    );
    return image;
  }
}
```
