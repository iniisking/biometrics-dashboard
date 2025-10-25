import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../model/chart_data.dart';
import '../../config/app_theme.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String unit;
  final Color color;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    // Validate data points to prevent crashes
    final validData = data
        .where(
          (point) =>
              point.x.isFinite &&
              point.y.isFinite &&
              !point.x.isNaN &&
              !point.y.isNaN,
        )
        .toList();

    if (validData.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(validData) * 1.1,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${_formatValue(rod.toY)} $unit',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < validData.length) {
                          final date = validData[index].date;
                          return Text(
                            '${date.month}/${date.day}',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _getInterval(validData),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatValue(value),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: validData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: point.y,
                        color: color,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text('No data available')),
    );
  }

  double _getMaxY(List<ChartDataPoint> data) {
    if (data.isEmpty) return 100;
    return data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  }

  double _getInterval(List<ChartDataPoint> data) {
    final maxY = _getMaxY(data);
    if (maxY <= 10) return 2;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    return maxY / 5;
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}

class PieChartWidget extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String title;

  const PieChartWidget({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    // Validate data points to prevent crashes
    final validData = data
        .where(
          (point) =>
              point.x.isFinite &&
              point.y.isFinite &&
              !point.x.isNaN &&
              !point.y.isNaN &&
              point.y > 0, // Pie charts need positive values
        )
        .toList();

    if (validData.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch events
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildSections(validData),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: _buildLegend(validData)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(List<ChartDataPoint> data) {
    final colors = AppTheme.chartColors;
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final total = data.fold(0.0, (sum, item) => sum + item.y);
      final percentage = (point.y / total * 100).round();

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: point.y,
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(List<ChartDataPoint> data) {
    final colors = AppTheme.chartColors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${point.date.month}/${point.date.day}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text('No data available')),
    );
  }
}

class AreaChartWidget extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String unit;
  final Color color;

  const AreaChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    // Validate data points to prevent crashes
    final validData = data
        .where(
          (point) =>
              point.x.isFinite &&
              point.y.isFinite &&
              !point.x.isNaN &&
              !point.y.isNaN,
        )
        .toList();

    if (validData.isEmpty) {
      return _buildEmptyChart();
    }

    // Area charts need at least 2 points to draw properly
    if (validData.length < 2) {
      return _buildEmptyChart();
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Builder(
              builder: (context) {
                try {
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: _getBottomInterval(validData),
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < validData.length) {
                                final date = validData[index].date;
                                return Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: _getInterval(validData),
                            getTitlesWidget: (value, meta) {
                              return Text(
                                _formatValue(value),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: validData
                              .map((point) => FlSpot(point.x, point.y))
                              .toList(),
                          isCurved: true,
                          color: color,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${_formatValue(spot.y)} $unit',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      minX: _getMinX(validData),
                      maxX: _getMaxX(validData) == _getMinX(validData)
                          ? _getMinX(validData) + 1.0
                          : _getMaxX(validData),
                      minY: _getMinY(validData),
                      maxY: _getMaxY(validData) == _getMinY(validData)
                          ? _getMinY(validData) + 1.0
                          : _getMaxY(validData),
                    ),
                  );
                } catch (e) {
                  return Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chart Error',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Unable to display area chart: $e',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text('No data available')),
    );
  }

  double _getMinX(List<ChartDataPoint> data) {
    if (data.isEmpty) return 0;
    return data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxX(List<ChartDataPoint> data) {
    if (data.isEmpty) return 1;
    return data.map((e) => e.x).reduce((a, b) => a > b ? a : b);
  }

  double _getMinY(List<ChartDataPoint> data) {
    if (data.isEmpty) return 0;
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    return minY * 0.9;
  }

  double _getMaxY(List<ChartDataPoint> data) {
    if (data.isEmpty) return 100;
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return maxY * 1.1;
  }

  double _getInterval(List<ChartDataPoint> data) {
    final maxY = _getMaxY(data);
    if (maxY <= 10) return 2;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    return maxY / 5;
  }

  double _getBottomInterval(List<ChartDataPoint> data) {
    if (data.length <= 1) return 1;
    if (data.length <= 7) return 1;
    return data.length / 7;
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}
