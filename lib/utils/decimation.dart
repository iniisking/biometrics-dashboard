import 'dart:math';
import '../model/chart_data.dart';

class DecimationUtils {
  /// Largest Triangle Three Buckets (LTTB) decimation algorithm
  /// Preserves the most important data points for visualization
  static DecimatedData lttbDecimation(
    List<ChartDataPoint> data,
    int targetSize,
  ) {
    if (data.length <= targetSize) {
      return DecimatedData(
        points: data,
        originalSize: data.length,
        decimatedSize: data.length,
        compressionRatio: 1.0,
      );
    }

    if (targetSize < 2) {
      return DecimatedData(
        points: data.take(1).toList(),
        originalSize: data.length,
        decimatedSize: 1,
        compressionRatio: 1.0 / data.length,
      );
    }

    final List<ChartDataPoint> decimated = List.filled(targetSize, data[0]);
    decimated[targetSize - 1] = data[data.length - 1];

    final int bucketSize = (data.length - 2) ~/ (targetSize - 2);
    int a = 0;

    for (int i = 1; i < targetSize - 1; i++) {
      final int nextBucketStart = (i * bucketSize) + 1;
      final int nextBucketEnd = min(
        nextBucketStart + bucketSize,
        data.length - 1,
      );

      // Calculate the average point for next bucket
      double avgX = 0;
      double avgY = 0;
      for (int j = nextBucketStart; j < nextBucketEnd; j++) {
        avgX += data[j].x;
        avgY += data[j].y;
      }
      avgX /= (nextBucketEnd - nextBucketStart);
      avgY /= (nextBucketEnd - nextBucketStart);

      // Find the point in the current bucket that forms the largest triangle
      double maxArea = -1;
      int maxAreaIndex = nextBucketStart;

      for (int j = a + 1; j < nextBucketStart; j++) {
        final double area = _calculateTriangleArea(
          data[a].x,
          data[a].y,
          data[j].x,
          data[j].y,
          avgX,
          avgY,
        );

        if (area > maxArea) {
          maxArea = area;
          maxAreaIndex = j;
        }
      }

      decimated[i] = data[maxAreaIndex];
      a = nextBucketStart;
    }

    return DecimatedData(
      points: decimated,
      originalSize: data.length,
      decimatedSize: decimated.length,
      compressionRatio: decimated.length / data.length,
    );
  }

  /// Simple bucket mean decimation
  /// Faster but less accurate than LTTB
  static DecimatedData bucketMeanDecimation(
    List<ChartDataPoint> data,
    int targetSize,
  ) {
    if (data.length <= targetSize) {
      return DecimatedData(
        points: data,
        originalSize: data.length,
        decimatedSize: data.length,
        compressionRatio: 1.0,
      );
    }

    final List<ChartDataPoint> decimated = [];
    final int bucketSize = data.length ~/ targetSize;

    for (int i = 0; i < targetSize; i++) {
      final int start = i * bucketSize;
      final int end = min(start + bucketSize, data.length);

      if (start >= data.length) break;

      // Calculate mean values for this bucket
      double sumX = 0;
      double sumY = 0;
      int count = 0;

      for (int j = start; j < end; j++) {
        sumX += data[j].x;
        sumY += data[j].y;
        count++;
      }

      if (count > 0) {
        decimated.add(
          ChartDataPoint(
            x: sumX / count,
            y: sumY / count,
            date: data[start].date, // Use the first date in the bucket
          ),
        );
      }
    }

    return DecimatedData(
      points: decimated,
      originalSize: data.length,
      decimatedSize: decimated.length,
      compressionRatio: decimated.length / data.length,
    );
  }

  /// Calculate the area of a triangle formed by three points
  static double _calculateTriangleArea(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    return ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)).abs() / 2;
  }

  /// Calculate rolling mean and standard deviation for bands
  static List<ChartDataPoint> calculateRollingMean(
    List<ChartDataPoint> data,
    int windowSize,
  ) {
    if (data.length < windowSize) return data;

    final List<ChartDataPoint> rollingMean = [];

    for (int i = windowSize - 1; i < data.length; i++) {
      double sum = 0;
      for (int j = i - windowSize + 1; j <= i; j++) {
        sum += data[j].y;
      }

      rollingMean.add(
        ChartDataPoint(x: data[i].x, y: sum / windowSize, date: data[i].date),
      );
    }

    return rollingMean;
  }

  /// Calculate standard deviation for bands
  static List<double> calculateRollingStdDev(
    List<ChartDataPoint> data,
    int windowSize,
  ) {
    if (data.length < windowSize) return List.filled(data.length, 0.0);

    final List<double> stdDev = [];

    for (int i = windowSize - 1; i < data.length; i++) {
      double sum = 0;
      double sumSquared = 0;

      for (int j = i - windowSize + 1; j <= i; j++) {
        sum += data[j].y;
        sumSquared += data[j].y * data[j].y;
      }

      final double mean = sum / windowSize;
      final double variance = (sumSquared / windowSize) - (mean * mean);
      stdDev.add(sqrt(variance));
    }

    return stdDev;
  }
}
