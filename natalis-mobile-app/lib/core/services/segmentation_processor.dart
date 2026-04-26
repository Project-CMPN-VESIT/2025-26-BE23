import 'dart:typed_data';
import 'dart:math';
import 'package:image/image.dart' as img;

class MedicalHeadAnalysis {
  static const int maskSize = 256;
  static const int modelInputSize = 512;

  // ============================================================
  // 1️⃣ Logits → Binary Mask
  // ============================================================
  static List<int> logitsToMask(List<double> output) {
    final numPixels = maskSize * maskSize;
    List<int> mask = List.filled(numPixels, 0);

    for (int i = 0; i < numPixels; i++) {
      double c0 = output[i];
      double c1 = output[i + numPixels];

      // 🔥 Softmax
      double exp0 = exp(c0);
      double exp1 = exp(c1);
      double prob1 = exp1 / (exp0 + exp1);

      mask[i] = prob1 >= 0.5 ? 1 : 0;
    }

    return mask;
  }

  static List<int> fillHolesDynamic(List<int> mask, int size) {
    int w = size;
    int h = size;

    List<int> filled = List.from(mask);

    for (int y = 1; y < h - 1; y++) {
      for (int x = 1; x < w - 1; x++) {
        int idx = y * w + x;

        if (mask[idx] == 0) {
          int neighbors = 0;

          for (int dy = -1; dy <= 1; dy++) {
            for (int dx = -1; dx <= 1; dx++) {
              if (mask[(y + dy) * w + (x + dx)] == 1) {
                neighbors++;
              }
            }
          }

          if (neighbors >= 6) {
            filled[idx] = 1;
          }
        }
      }
    }

    return filled;
  }

  // ============================================================
  // 2️⃣ Largest Connected Component
  // ============================================================
  static List<int> largestComponentDynamic(List<int> mask, int size) {
    final visited = List<bool>.filled(mask.length, false);
    List<int> largest = [];

    int w = size;
    int h = size;

    List<int> dfs(int start) {
      List<int> stack = [start];
      List<int> comp = [];

      while (stack.isNotEmpty) {
        int idx = stack.removeLast();
        if (visited[idx] || mask[idx] == 0) continue;

        visited[idx] = true;
        comp.add(idx);

        int x = idx % w;
        int y = idx ~/ w;

        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            int nx = x + dx;
            int ny = y + dy;
            if (nx >= 0 && nx < w && ny >= 0 && ny < h) {
              stack.add(ny * w + nx);
            }
          }
        }
      }
      return comp;
    }

    for (int i = 0; i < mask.length; i++) {
      if (!visited[i] && mask[i] == 1) {
        final comp = dfs(i);
        if (comp.length > largest.length) {
          largest = comp;
        }
      }
    }

    List<int> cleaned = List.filled(mask.length, 0);
    for (var i in largest) cleaned[i] = 1;

    return cleaned;
  }

  // ============================================================
  // 3️⃣ Extract Contour
  // ============================================================
  static List<Point> extractContourDynamic(List<int> mask, int size) {
    List<Point> pts = [];
    int w = size;
    int h = size;

    for (int y = 1; y < h - 1; y++) {
      for (int x = 1; x < w - 1; x++) {
        int idx = y * w + x;
        if (mask[idx] == 1) {
          if (mask[idx - 1] == 0 ||
              mask[idx + 1] == 0 ||
              mask[idx - w] == 0 ||
              mask[idx + w] == 0) {
            pts.add(Point(x.toDouble(), y.toDouble()));
          }
        }
      }
    }
    return pts;
  }

  // ============================================================
  // 4️⃣ Fit Ellipse (Covariance Method)
  // ============================================================
  static Map<String, double> fitEllipse(List<Point> pts) {
    double meanX = 0;
    double meanY = 0;

    for (var p in pts) {
      meanX += p.x;
      meanY += p.y;
    }

    meanX /= pts.length;
    meanY /= pts.length;

    double sxx = 0, syy = 0, sxy = 0;

    for (var p in pts) {
      double dx = p.x - meanX;
      double dy = p.y - meanY;
      sxx += dx * dx;
      syy += dy * dy;
      sxy += dx * dy;
    }

    sxx /= pts.length;
    syy /= pts.length;
    sxy /= pts.length;

    double term = sqrt((sxx - syy) * (sxx - syy) + 4 * sxy * sxy);

    double major = sqrt(2 * (sxx + syy + term));
    double minor = sqrt(2 * (sxx + syy - term));

    return {"cx": meanX, "cy": meanY, "major": major, "minor": minor};
  }

  // ============================================================
  // 5️⃣ HC Calculation (Ramanujan II)
  // ============================================================
  static double computeHCmm(
    double majorPx,
    double minorPx,
    double pixelSizeMm,
  ) {
    double a = (majorPx * pixelSizeMm) / 2.0;
    double b = (minorPx * pixelSizeMm) / 2.0;

    return pi * (3 * (a + b) - sqrt((3 * a + b) * (a + 3 * b)));
  }

  // ============================================================
  // 6️⃣ GA from HC
  // ============================================================
  static double? gaWeeksFromHC(double hcMm) {
    if (hcMm <= 0) return null;

    double gaDays = exp(
      0.05970 * pow(log(hcMm), 2) + 6.409e-9 * pow(hcMm, 3) + 3.3258,
    );

    double gaWeeks = gaDays / 7.0;

    if (gaWeeks < 12 || gaWeeks > 42) {
      return null;
    }

    return gaWeeks;
  }

  // ============================================================
  // 7️⃣ Full Medical Pipeline
  // ============================================================
  static Map<String, dynamic> analyze(
    Uint8List originalBytes,
    List<double> logits,
    double pixelSizeMm,
  ) {
    // --------------------------------------------------
    // 🔥 1️⃣ Determine mask size dynamically
    // --------------------------------------------------
    int numPixels = logits.length ~/ 2;
    int maskSize = sqrt(numPixels).toInt();

    // --------------------------------------------------
    // 🔥 2️⃣ Convert logits → mask
    // --------------------------------------------------
    List<int> mask = List.filled(numPixels, 0);

    for (int i = 0; i < numPixels; i++) {
      double c0 = logits[i];
      double c1 = logits[i + numPixels];

      double exp0 = exp(c0);
      double exp1 = exp(c1);
      double prob1 = exp1 / (exp0 + exp1);

      mask[i] = prob1 >= 0.5 ? 1 : 0;
    }

    mask = largestComponentDynamic(mask, maskSize);
    mask = fillHolesDynamic(mask, maskSize);

    var contour = extractContourDynamic(mask, maskSize);

    if (contour.length < 5) {
      return {"image": originalBytes, "hc_mm": null, "ga_weeks": null};
    }

    var ellipse = fitEllipse(contour);

    // --------------------------------------------------
    // 🔥 3️⃣ Decode original image
    // --------------------------------------------------
    img.Image base = img.decodeImage(originalBytes)!;

    int originalW = base.width;
    int originalH = base.height;

    // --------------------------------------------------
    // 🔥 4️⃣ Proper scaling (REAL FIX)
    // --------------------------------------------------
    double scaleX = originalW / maskSize;
    double scaleY = originalH / maskSize;

    double cx = ellipse["cx"]! * scaleX;
    double cy = ellipse["cy"]! * scaleY;
    double correction = 1.88; // start with 1.05–1.10 range

    double major = ellipse["major"]! * scaleX * correction;
    double minor = ellipse["minor"]! * scaleY * correction;

    double hcMm = computeHCmm(major, minor, pixelSizeMm);
    double? gaWeeks = gaWeeksFromHC(hcMm);

    // --------------------------------------------------
    // 🔥 5️⃣ Draw ellipse on ORIGINAL image size
    // --------------------------------------------------
    int steps = 360; // smoother ellipse
    int thickness = 2;

    for (int i = 0; i < steps; i++) {
      double theta = 2 * pi * i / steps;

      int x = (cx + (major / 2) * cos(theta)).toInt();
      int y = (cy + (minor / 2) * sin(theta)).toInt();

      for (int dx = -thickness; dx <= thickness; dx++) {
        for (int dy = -thickness; dy <= thickness; dy++) {
          int px = x + dx;
          int py = y + dy;

          if (px >= 0 && px < originalW && py >= 0 && py < originalH) {
            base.setPixel(
              px,
              py,
              img.ColorRgb8(0, 255, 80), // bright neon green
            );
          }
        }
      }
    }

    return {
      "image": Uint8List.fromList(img.encodePng(base)),
      "hc_mm": hcMm,
      "ga_weeks": gaWeeks,
    };
  }
}
