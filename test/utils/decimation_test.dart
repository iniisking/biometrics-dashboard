import 'package:flutter_test/flutter_test.dart';
import 'package:biometrics_dashboard/utils/decimation.dart';
import 'package:biometrics_dashboard/model/chart_data.dart';

void main() {
  group('DecimationUtils', () {
    late List<ChartDataPoint> testData;

    setUp(() {
      // Create test data with known min/max values
      testData = List.generate(100, (index) {
        return ChartDataPoint(
          x: index.toDouble(),
          y: index * 2.0, // Linear relationship for easy testing
          date: DateTime(2024, 1, 1).add(Duration(days: index)),
        );
      });
    });

    test('LTTB decimation preserves min and max values', () {
      const targetSize = 10;
      final result = DecimationUtils.lttbDecimation(testData, targetSize);

      // Check that we got the expected number of points
      expect(result.decimatedSize, targetSize);
      expect(result.originalSize, testData.length);
      expect(result.compressionRatio, lessThan(1.0));

      // Check that min and max values are preserved
      final originalMin = testData
          .map((e) => e.y)
          .reduce((a, b) => a < b ? a : b);
      final originalMax = testData
          .map((e) => e.y)
          .reduce((a, b) => a > b ? a : b);

      final decimatedMin = result.points
          .map((e) => e.y)
          .reduce((a, b) => a < b ? a : b);
      final decimatedMax = result.points
          .map((e) => e.y)
          .reduce((a, b) => a > b ? a : b);

      expect(decimatedMin, equals(originalMin));
      expect(decimatedMax, equals(originalMax));
    });

    test('LTTB decimation handles small datasets', () {
      final smallData = testData.take(5).toList();
      final result = DecimationUtils.lttbDecimation(smallData, 10);

      expect(result.points.length, equals(smallData.length));
      expect(result.compressionRatio, equals(1.0));
    });

    test('LTTB decimation handles target size of 1', () {
      final result = DecimationUtils.lttbDecimation(testData, 1);

      expect(result.points.length, equals(1));
      expect(result.points.first.x, equals(testData.first.x));
      expect(result.points.first.y, equals(testData.first.y));
    });

    test('Bucket mean decimation preserves approximate mean', () {
      const targetSize = 20;
      final result = DecimationUtils.bucketMeanDecimation(testData, targetSize);

      expect(result.decimatedSize, targetSize);
      expect(result.originalSize, testData.length);

      // Calculate original mean
      final originalMean =
          testData.map((e) => e.y).reduce((a, b) => a + b) / testData.length;

      // Calculate decimated mean
      final decimatedMean =
          result.points.map((e) => e.y).reduce((a, b) => a + b) /
          result.points.length;

      // Mean should be approximately the same (within 5% tolerance)
      expect(decimatedMean, closeTo(originalMean, originalMean * 0.05));
    });

    test('Rolling mean calculation works correctly', () {
      const windowSize = 7;
      final rollingMean = DecimationUtils.calculateRollingMean(
        testData,
        windowSize,
      );

      expect(rollingMean.length, equals(testData.length - windowSize + 1));

      // Check first rolling mean value
      final expectedFirstMean =
          testData.take(windowSize).map((e) => e.y).reduce((a, b) => a + b) /
          windowSize;
      expect(rollingMean.first.y, closeTo(expectedFirstMean, 0.001));
    });

    test('Rolling standard deviation calculation works correctly', () {
      const windowSize = 7;
      final stdDev = DecimationUtils.calculateRollingStdDev(
        testData,
        windowSize,
      );

      expect(stdDev.length, equals(testData.length - windowSize + 1));

      // All standard deviations should be non-negative
      for (final value in stdDev) {
        expect(value, greaterThanOrEqualTo(0.0));
      }
    });

    test('Decimation handles empty data gracefully', () {
      final emptyData = <ChartDataPoint>[];
      final result = DecimationUtils.lttbDecimation(emptyData, 10);

      expect(result.points, isEmpty);
      expect(result.originalSize, equals(0));
      expect(result.decimatedSize, equals(0));
    });
  });
}
