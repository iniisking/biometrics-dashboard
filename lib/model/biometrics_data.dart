import 'package:json_annotation/json_annotation.dart';

part 'biometrics_data.g.dart';

@JsonSerializable()
class BiometricsData {
  final String date;
  final double hrv;
  final int rhr;
  final int steps;
  final int sleepScore;

  const BiometricsData({
    required this.date,
    required this.hrv,
    required this.rhr,
    required this.steps,
    required this.sleepScore,
  });

  factory BiometricsData.fromJson(Map<String, dynamic> json) =>
      _$BiometricsDataFromJson(json);

  Map<String, dynamic> toJson() => _$BiometricsDataToJson(this);

  DateTime get dateTime => DateTime.parse(date);
}

@JsonSerializable()
class JournalEntry {
  final String date;
  final int mood; // 1-5 scale
  final String note;

  const JournalEntry({
    required this.date,
    required this.mood,
    required this.note,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);

  DateTime get dateTime => DateTime.parse(date);
}

@JsonSerializable()
class BiometricsResponse {
  final List<BiometricsData> data;
  final bool success;
  final String? error;

  const BiometricsResponse({
    required this.data,
    required this.success,
    this.error,
  });

  factory BiometricsResponse.fromJson(Map<String, dynamic> json) =>
      _$BiometricsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BiometricsResponseToJson(this);
}

@JsonSerializable()
class JournalResponse {
  final List<JournalEntry> data;
  final bool success;
  final String? error;

  const JournalResponse({
    required this.data,
    required this.success,
    this.error,
  });

  factory JournalResponse.fromJson(Map<String, dynamic> json) =>
      _$JournalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JournalResponseToJson(this);
}
