import 'package:flutter/material.dart';
import '../model/biometrics_data.dart';
import '../model/chart_data.dart';
import '../services/data_service.dart';
import '../utils/logger.dart';
import '../utils/decimation.dart';
import '../utils/constants.dart';

class DashboardController extends ChangeNotifier {
  final DataService _dataService = DataService();

  // State variables
  bool _isLoading = false;
  String? _error;
  List<BiometricsData> _biometricsData = [];
  List<JournalEntry> _journalData = [];
  DateRange _selectedRange = DateRange.sevenDays;
  bool _isLargeDataset = false;
  ChartDataPoint? _selectedPoint;

  // Chart data
  List<ChartDataPoint> _hrvPoints = [];
  List<ChartDataPoint> _rhrPoints = [];
  List<ChartDataPoint> _stepsPoints = [];
  List<ChartDataPoint> _hrvRollingMean = [];
  List<double> _hrvStdDev = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BiometricsData> get biometricsData => _biometricsData;
  List<JournalEntry> get journalData => _journalData;
  DateRange get selectedRange => _selectedRange;
  bool get isLargeDataset => _isLargeDataset;
  ChartDataPoint? get selectedPoint => _selectedPoint;

  List<ChartDataPoint> get hrvPoints => _hrvPoints;
  List<ChartDataPoint> get rhrPoints => _rhrPoints;
  List<ChartDataPoint> get stepsPoints => _stepsPoints;
  List<ChartDataPoint> get hrvRollingMean => _hrvRollingMean;
  List<double> get hrvStdDev => _hrvStdDev;

  // Initialize data
  Future<void> initializeData() async {
    Logger.debug('Starting data initialization...');
    _setLoading(true);
    _clearError();

    try {
      Logger.debug('Loading data from services...');
      final futures = await Future.wait([
        _dataService.loadBiometricsData(),
        _dataService.loadJournalData(),
      ]);

      final biometricsResponse = futures[0] as BiometricsResponse;
      final journalResponse = futures[1] as JournalResponse;

      Logger.debug('Biometrics success: ${biometricsResponse.success}');
      Logger.debug('Journal success: ${journalResponse.success}');

      if (!biometricsResponse.success) {
        Logger.error('Biometrics failed: ${biometricsResponse.error}');
        _setError(biometricsResponse.error ?? 'Failed to load biometrics data');
        return;
      }

      if (!journalResponse.success) {
        Logger.error('Journal failed: ${journalResponse.error}');
        _setError(journalResponse.error ?? 'Failed to load journal data');
        return;
      }

      _biometricsData = biometricsResponse.data;
      _journalData = journalResponse.data;

      Logger.info(
        'Loaded ${_biometricsData.length} biometrics and ${_journalData.length} journal entries',
      );

      // Debug: Show first few data points
      if (_biometricsData.isNotEmpty) {
        Logger.debug('First data point: ${_biometricsData.first.date}');
        Logger.debug('Last data point: ${_biometricsData.last.date}');
      }

      await _updateChartData();
    } catch (e) {
      Logger.error('Unexpected error: $e');
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
      Logger.debug('Data initialization complete');
    }
  }

  // Toggle large dataset for performance testing
  void toggleLargeDataset() {
    _isLargeDataset = !_isLargeDataset;
    _updateChartData();
    notifyListeners();
  }

  // Change date range
  void changeDateRange(DateRange range) {
    _selectedRange = range;
    _updateChartData();
    notifyListeners();
  }

  // Update selected point for tooltip
  void updateSelectedPoint(ChartDataPoint? point) {
    _selectedPoint = point;
    notifyListeners();
  }

  // Retry loading data
  Future<void> retry() async {
    await initializeData();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  Future<void> _updateChartData() async {
    try {
      if (_biometricsData.isEmpty) {
        Logger.debug('No biometrics data available');
        return;
      }

      Logger.debug(
        'Updating chart data with ${_biometricsData.length} total records',
      );

      // For demo purposes, let's show the most recent data regardless of date
      // In a real app, you'd want proper date filtering
      List<BiometricsData> filteredData;

      if (_selectedRange == DateRange.sevenDays) {
        // Show last 7 data points
        filteredData = _biometricsData.length > 7
            ? _biometricsData.sublist(_biometricsData.length - 7)
            : _biometricsData;
      } else if (_selectedRange == DateRange.thirtyDays) {
        // Show last 30 data points
        filteredData = _biometricsData.length > 30
            ? _biometricsData.sublist(_biometricsData.length - 30)
            : _biometricsData;
      } else {
        // Show all data for 90 days
        filteredData = _biometricsData;
      }

      Logger.debug(
        'Selected ${filteredData.length} records for ${_selectedRange.displayName} view',
      );

      // Generate large dataset if enabled
      if (_isLargeDataset) {
        final largeData = _dataService.generateLargeDataset(
          AppConstants.maxDataPoints,
        );
        if (_selectedRange == DateRange.sevenDays) {
          filteredData = largeData.length > 7
              ? largeData.sublist(largeData.length - 7)
              : largeData;
        } else if (_selectedRange == DateRange.thirtyDays) {
          filteredData = largeData.length > 30
              ? largeData.sublist(largeData.length - 30)
              : largeData;
        } else {
          filteredData = largeData;
        }
        Logger.debug('Using large dataset with ${filteredData.length} records');
      }

      // Sort by date
      filteredData.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      // Convert to chart points with error handling
      _hrvPoints = _convertToChartPoints(filteredData, (data) => data.hrv);
      _rhrPoints = _convertToChartPoints(
        filteredData,
        (data) => data.rhr.toDouble(),
      );
      _stepsPoints = _convertToChartPoints(
        filteredData,
        (data) => data.steps.toDouble(),
      );

      // Validate that we have valid data points
      if (_hrvPoints.isEmpty && _rhrPoints.isEmpty && _stepsPoints.isEmpty) {
        Logger.debug('No valid chart data points after conversion');
        return;
      }

      // Apply decimation for performance
      final targetSize = _getTargetSize();

      if (_hrvPoints.length > targetSize) {
        try {
          final decimatedHrv = DecimationUtils.lttbDecimation(
            _hrvPoints,
            targetSize,
          );
          _hrvPoints = decimatedHrv.points;

          final decimatedRhr = DecimationUtils.lttbDecimation(
            _rhrPoints,
            targetSize,
          );
          _rhrPoints = decimatedRhr.points;

          final decimatedSteps = DecimationUtils.lttbDecimation(
            _stepsPoints,
            targetSize,
          );
          _stepsPoints = decimatedSteps.points;
        } catch (e) {
          Logger.error('Error during decimation: $e');
          // Continue with original data if decimation fails
        }
      }

      // Calculate rolling mean and std dev for HRV bands
      _calculateHrvBands();

      Logger.debug('Chart data update completed successfully');
    } catch (e) {
      Logger.error('Error updating chart data: $e');
      // Reset to empty data to prevent crashes
      _hrvPoints = [];
      _rhrPoints = [];
      _stepsPoints = [];
      _hrvRollingMean = [];
      _hrvStdDev = [];
    }
  }

  List<ChartDataPoint> _convertToChartPoints(
    List<BiometricsData> data,
    double Function(BiometricsData) valueExtractor,
  ) {
    return data
        .map((item) {
          final yValue = valueExtractor(item);
          final xValue = item.dateTime.millisecondsSinceEpoch.toDouble();

          // Validate and sanitize values
          final sanitizedY = _sanitizeValue(yValue);
          final sanitizedX = _sanitizeValue(xValue);

          return ChartDataPoint(
            x: sanitizedX,
            y: sanitizedY,
            date: item.dateTime,
          );
        })
        .where(
          (point) =>
              point.x.isFinite &&
              point.y.isFinite &&
              !point.x.isNaN &&
              !point.y.isNaN,
        )
        .toList();
  }

  double _sanitizeValue(double value) {
    if (value.isNaN || value.isInfinite) {
      return 0.0;
    }
    return value;
  }

  int _getTargetSize() {
    switch (_selectedRange) {
      case DateRange.sevenDays:
        return 50; // ~7 points per day
      case DateRange.thirtyDays:
        return 100; // ~3 points per day
      case DateRange.ninetyDays:
        return 200; // ~2 points per day
    }
  }

  void _calculateHrvBands() {
    if (_hrvPoints.length < 7) {
      _hrvRollingMean = [];
      _hrvStdDev = [];
      return;
    }

    try {
      _hrvRollingMean = DecimationUtils.calculateRollingMean(_hrvPoints, 7);
      _hrvStdDev = DecimationUtils.calculateRollingStdDev(_hrvPoints, 7);

      // Validate the calculated values
      _hrvRollingMean = _hrvRollingMean
          .where(
            (point) =>
                point.x.isFinite &&
                point.y.isFinite &&
                !point.x.isNaN &&
                !point.y.isNaN,
          )
          .toList();

      _hrvStdDev = _hrvStdDev
          .where((value) => value.isFinite && !value.isNaN)
          .toList();
    } catch (e) {
      Logger.error('Error calculating HRV bands: $e');
      _hrvRollingMean = [];
      _hrvStdDev = [];
    }
  }

  // Get journal entries for a specific date
  List<JournalEntry> getJournalEntriesForDate(DateTime date) {
    return _journalData.where((entry) {
      return entry.dateTime.year == date.year &&
          entry.dateTime.month == date.month &&
          entry.dateTime.day == date.day;
    }).toList();
  }

  // Get mood emoji for display
  String getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }
}
