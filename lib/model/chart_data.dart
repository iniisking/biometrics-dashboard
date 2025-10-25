import 'package:flutter/material.dart';

class ChartDataPoint {
  final double x;
  final double y;
  final DateTime date;
  final String? label;

  const ChartDataPoint({
    required this.x,
    required this.y,
    required this.date,
    this.label,
  });
}

class ChartSeries {
  final List<ChartDataPoint> points;
  final String title;
  final Color color;
  final String unit;

  const ChartSeries({
    required this.points,
    required this.title,
    required this.color,
    required this.unit,
  });
}

class DecimatedData {
  final List<ChartDataPoint> points;
  final int originalSize;
  final int decimatedSize;
  final double compressionRatio;

  const DecimatedData({
    required this.points,
    required this.originalSize,
    required this.decimatedSize,
    required this.compressionRatio,
  });
}

enum DateRange { sevenDays, thirtyDays, ninetyDays }

extension DateRangeExtension on DateRange {
  int get days {
    switch (this) {
      case DateRange.sevenDays:
        return 7;
      case DateRange.thirtyDays:
        return 30;
      case DateRange.ninetyDays:
        return 90;
    }
  }

  String get displayName {
    switch (this) {
      case DateRange.sevenDays:
        return '7d';
      case DateRange.thirtyDays:
        return '30d';
      case DateRange.ninetyDays:
        return '90d';
    }
  }
}
