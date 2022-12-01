import 'dart:math';

import 'yuv_color.dart';
import 'yuv_image.dart';

/// many thanks to Aryaman Sharda for his outstanding blog on gaussian blur
/// https://aryamansharda.medium.com/image-filters-gaussian-blur-eb36db6781b1
extension YuvImageGaussianBlurExt on YuvImage {
  YuvImage copyBlur(int radius) => copy(this).blur(radius);

  YuvImage blur(int radius) {
    final double sigma = max(radius / 2, 1);
    final exponentDenominator = (2 * sigma * sigma);

    final int kernelWidth = ((2 * radius) + 1).toInt();
    final List<List<num>> kernel =
        List.generate(kernelWidth, (index) => List.filled(kernelWidth, 0.0, growable: false), growable: false);
    num sum = 0.0;

    // Populate every position in the kernel with the respective Gaussian distribution value
    // Remember that x and y represent how far we are away from the CENTER pixel

    for (int x = -radius; x < radius; x++) {
      for (int y = -radius; y < radius; y++) {
        int exponentNumerator = -(x * x + y * y);
        num eExpression = pow(e, exponentNumerator / exponentDenominator);
        num kernelValue = (eExpression / (2 * pi * sigma * sigma));

        // We add radius to the indices to prevent out of bound issues because x and y can be negative
        kernel[x + radius][y + radius] = kernelValue;
        sum += kernelValue;
      }
    }

    // Normalize the kernel
    // This ensures that all of the values in the kernel together add up to 1
    for (int x = 0; x < kernelWidth; x++) {
      for (int y = 0; y < kernelWidth; y++) {
        kernel[x][y] /= sum;
      }
    }

    for (int x = radius; x < width - radius; x++) {
      for (int y = radius; y < height - radius; y++) {
        num yp = 0;
        num up = 0;
        num vp = 0;

        for (int kx = -radius; kx < radius; kx++) {
          for (int ky = -radius; ky < radius; ky++) {
            num kernelValue = kernel[kx + radius][ky + radius];
            final nearColor = getYuvColor(x - kx, y - ky);
            yp += nearColor.yr * kernelValue;
            up += nearColor.ug * kernelValue;
            vp += nearColor.vb * kernelValue;
          }
        }

        setYuvColor(x, y, YuvColor.yuvToInt(yp.toInt(), up.toInt(), vp.toInt()));
      }
    }

    return this;
  }
}
