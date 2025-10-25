import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../model/biometrics_data.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';

class DataService {
  static const String _biometricsAssetPath = 'assets/biometrics_90d.json';
  static const String _journalsAssetPath = 'assets/journals.json';

  // Simulate 700-1200ms latency and ~10% failure rate
  static const int _minLatencyMs = AppConstants.minLatencyMs;
  static const int _maxLatencyMs = AppConstants.maxLatencyMs;
  static const double _failureRate = AppConstants.failureRate;

  final Random _random = Random();

  Future<BiometricsResponse> loadBiometricsData() async {
    try {
      Logger.debug('Loading biometrics data from: $_biometricsAssetPath');

      // Simulate network latency
      await _simulateLatency();

      // Simulate random failures
      if (_random.nextDouble() < _failureRate) {
        throw Exception('Simulated network failure');
      }

      final String jsonString = await rootBundle.loadString(
        _biometricsAssetPath,
      );
      Logger.debug('Loaded ${jsonString.length} characters of JSON data');

      final List<dynamic> jsonList = json.decode(jsonString);
      Logger.debug('Parsed ${jsonList.length} data points');

      final List<BiometricsData> data = jsonList
          .map((json) => BiometricsData.fromJson(json as Map<String, dynamic>))
          .toList();

      Logger.info('Successfully loaded ${data.length} biometrics records');
      return BiometricsResponse(data: data, success: true);
    } catch (e) {
      Logger.error('Error loading biometrics data: $e');
      return BiometricsResponse(data: [], success: false, error: e.toString());
    }
  }

  Future<JournalResponse> loadJournalData() async {
    try {
      // Simulate network latency
      await _simulateLatency();

      // Simulate random failures
      if (_random.nextDouble() < _failureRate) {
        throw Exception('Simulated network failure');
      }

      final String jsonString = await rootBundle.loadString(_journalsAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      final List<JournalEntry> data = jsonList
          .map((json) => JournalEntry.fromJson(json as Map<String, dynamic>))
          .toList();

      return JournalResponse(data: data, success: true);
    } catch (e) {
      return JournalResponse(data: [], success: false, error: e.toString());
    }
  }

  Future<void> _simulateLatency() async {
    final int latencyMs =
        _minLatencyMs + _random.nextInt(_maxLatencyMs - _minLatencyMs + 1);
    await Future.delayed(Duration(milliseconds: latencyMs));
  }

  // Generate large dataset for performance testing
  List<BiometricsData> generateLargeDataset(int count) {
    final List<BiometricsData> data = [];
    final DateTime startDate = DateTime.now().subtract(Duration(days: count));

    for (int i = 0; i < count; i++) {
      final DateTime date = startDate.add(Duration(days: i));
      data.add(
        BiometricsData(
          date: date.toIso8601String().split('T')[0],
          hrv: 50 + _random.nextDouble() * 20, // 50-70 range
          rhr: 55 + _random.nextInt(20), // 55-75 range
          steps: 3000 + _random.nextInt(8000), // 3000-11000 range
          sleepScore: 60 + _random.nextInt(40), // 60-100 range
        ),
      );
    }

    return data;
  }
}
