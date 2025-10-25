// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometrics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiometricsData _$BiometricsDataFromJson(Map<String, dynamic> json) =>
    BiometricsData(
      date: json['date'] as String,
      hrv: (json['hrv'] as num).toDouble(),
      rhr: (json['rhr'] as num).toInt(),
      steps: (json['steps'] as num).toInt(),
      sleepScore: (json['sleepScore'] as num).toInt(),
    );

Map<String, dynamic> _$BiometricsDataToJson(BiometricsData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'hrv': instance.hrv,
      'rhr': instance.rhr,
      'steps': instance.steps,
      'sleepScore': instance.sleepScore,
    };

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) => JournalEntry(
  date: json['date'] as String,
  mood: (json['mood'] as num).toInt(),
  note: json['note'] as String,
);

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'date': instance.date,
      'mood': instance.mood,
      'note': instance.note,
    };

BiometricsResponse _$BiometricsResponseFromJson(Map<String, dynamic> json) =>
    BiometricsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => BiometricsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$BiometricsResponseToJson(BiometricsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'error': instance.error,
    };

JournalResponse _$JournalResponseFromJson(Map<String, dynamic> json) =>
    JournalResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$JournalResponseToJson(JournalResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'error': instance.error,
    };
