import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../model/chart_data.dart';
import '../../utils/color_utils.dart';
import '../../utils/responsive_utils.dart';

class BaseChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String unit;
  final Color color;
  final ChartDataPoint? selectedPoint;
  final VoidCallback? onTap;
  final List<ChartDataPoint>? rollingMean;
  final List<double>? stdDev;
  final bool showBands;

  const BaseChart({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    required this.color,
    this.selectedPoint,
    this.onTap,
    this.rollingMean,
    this.stdDev,
    this.showBands = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart(context);
    }

    return Container(
      height: ResponsiveUtils.getChartHeight(context),
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
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
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getHorizontalInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: ColorUtils.withMediumOpacity(Colors.grey),
                      strokeWidth: 1,
                    );
                  },
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
                      interval: _getBottomInterval(),
                      getTitlesWidget: (value, meta) {
                        return _buildBottomTitle(value, meta);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _getLeftInterval(),
                      getTitlesWidget: (value, meta) {
                        return _buildLeftTitle(value, meta);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: _buildLineBarsData(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${_formatValue(spot.y)} $unit',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minX: data.first.x,
                maxX: data.last.x,
                minY: _getMinY(),
                maxY: _getMaxY(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    return Container(
      height: ResponsiveUtils.getChartHeight(context),
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    final List<LineChartBarData> bars = [];

    // Main data line
    bars.add(
      LineChartBarData(
        spots: data.map((point) => FlSpot(point.x, point.y)).toList(),
        isCurved: true,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    );

    // Rolling mean and bands if available
    if (showBands && rollingMean != null && stdDev != null) {
      // Upper band (mean + std)
      if (rollingMean!.length == stdDev!.length) {
        bars.add(
          LineChartBarData(
            spots: rollingMean!.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final upperY = point.y + stdDev![index];
              return FlSpot(point.x, upperY);
            }).toList(),
            isCurved: true,
            color: ColorUtils.withMediumOpacity(color),
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );

        // Lower band (mean - std)
        bars.add(
          LineChartBarData(
            spots: rollingMean!.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final lowerY = point.y - stdDev![index];
              return FlSpot(point.x, lowerY);
            }).toList(),
            isCurved: true,
            color: ColorUtils.withMediumOpacity(color),
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: ColorUtils.withLightOpacity(color),
            ),
          ),
        );

        // Rolling mean line
        bars.add(
          LineChartBarData(
            spots: rollingMean!
                .map((point) => FlSpot(point.x, point.y))
                .toList(),
            isCurved: true,
            color: ColorUtils.withHighOpacity(color),
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );
      }
    }

    return bars;
  }

  double _getHorizontalInterval() {
    final range = _getMaxY() - _getMinY();
    if (range <= 10) return 2;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    return range / 5;
  }

  double _getBottomInterval() {
    if (data.length <= 7) return data.last.x - data.first.x;
    return (data.last.x - data.first.x) / 7;
  }

  double _getLeftInterval() {
    return _getHorizontalInterval();
  }

  double _getMinY() {
    if (data.isEmpty) return 0;
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    return minY * 0.9; // Add some padding
  }

  double _getMaxY() {
    if (data.isEmpty) return 100;
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return maxY * 1.1; // Add some padding
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return Text(
      '${date.month}/${date.day}',
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Text(
      _formatValue(value),
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}
