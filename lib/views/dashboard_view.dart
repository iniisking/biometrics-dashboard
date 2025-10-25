import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controller/dashboard_controller.dart';
import '../controller/theme_controller.dart';
import '../model/chart_data.dart';
import '../config/app_theme.dart';
import '../utils/constants.dart';
import '../utils/animation_utils.dart';
import '../utils/responsive_utils.dart';
import 'widgets/base_chart.dart';
import 'widgets/chart_types.dart';
import 'widgets/range_selector.dart';
import 'widgets/tooltip_overlay.dart';
import 'widgets/shimmer_loading.dart';
import 'widgets/error_widget.dart' as custom;
import 'widgets/empty_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedChartType = AppConstants.lineChart;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationUtils.createController(
      vsync: this,
      duration: AnimationUtils.slowDuration,
    );
    _fadeAnimation = AnimationUtils.createFadeAnimation(_fadeController);

    // Initialize data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().initializeData();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biometrics Dashboard',
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          // Theme toggle
          Consumer<ThemeController>(
            builder: (context, themeController, child) {
              return IconButton(
                onPressed: themeController.toggleTheme,
                icon: Icon(
                  themeController.isDarkMode
                      ? LucideIcons.sun
                      : LucideIcons.moon,
                ),
                tooltip: 'Toggle theme',
              );
            },
          ),
          // Chart type selector
          PopupMenuButton<String>(
            icon: ResponsiveUtils.isMobile(context)
                ? Icon(_getChartTypeIcon(_selectedChartType))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getChartTypeIcon(_selectedChartType),
                        size: ResponsiveUtils.getIconSize(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getChartTypeName(_selectedChartType),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: ResponsiveUtils.getIconSize(context) * 0.7,
                      ),
                    ],
                  ),
            tooltip: 'Chart type',
            onSelected: (value) {
              setState(() {
                _selectedChartType = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AppConstants.lineChart,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.trendingUp,
                      color: _selectedChartType == AppConstants.lineChart
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Line Chart',
                      style: TextStyle(
                        fontWeight: _selectedChartType == AppConstants.lineChart
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedChartType == AppConstants.lineChart
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (_selectedChartType == AppConstants.lineChart)
                      const Spacer(),
                    if (_selectedChartType == AppConstants.lineChart)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: AppConstants.barChart,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.barChart3,
                      color: _selectedChartType == AppConstants.barChart
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Bar Chart',
                      style: TextStyle(
                        fontWeight: _selectedChartType == AppConstants.barChart
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedChartType == AppConstants.barChart
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (_selectedChartType == AppConstants.barChart)
                      const Spacer(),
                    if (_selectedChartType == AppConstants.barChart)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: AppConstants.pieChart,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.pieChart,
                      color: _selectedChartType == AppConstants.pieChart
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pie Chart',
                      style: TextStyle(
                        fontWeight: _selectedChartType == AppConstants.pieChart
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedChartType == AppConstants.pieChart
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (_selectedChartType == AppConstants.pieChart)
                      const Spacer(),
                    if (_selectedChartType == AppConstants.pieChart)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Large dataset toggle
          Consumer<DashboardController>(
            builder: (context, controller, child) {
              return ResponsiveUtils.isMobile(context)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: controller.retry,
                          icon: Icon(
                            LucideIcons.refreshCw,
                            size: ResponsiveUtils.getIconSize(context),
                          ),
                          tooltip: 'Refresh data',
                        ),
                        Switch(
                          value: controller.isLargeDataset,
                          onChanged: (_) => controller.toggleLargeDataset(),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Large Dataset',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              12,
                            ),
                          ),
                        ),
                        Switch(
                          value: controller.isLargeDataset,
                          onChanged: (_) => controller.toggleLargeDataset(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: controller.retry,
                          icon: Icon(
                            LucideIcons.refreshCw,
                            size: ResponsiveUtils.getIconSize(context),
                          ),
                          tooltip: 'Refresh data',
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<DashboardController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const ShimmerLoading();
            }

            if (controller.error != null) {
              return custom.ErrorWidget(
                error: controller.error!,
                onRetry: controller.retry,
              );
            }

            if (controller.biometricsData.isEmpty && !controller.isLoading) {
              return const EmptyWidget();
            }

            return Column(
              children: [
                // Range selector
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RangeSelector(
                    selectedRange: controller.selectedRange,
                    onRangeChanged: controller.changeDateRange,
                  ),
                ),

                // Charts
                Expanded(
                  child: ResponsiveUtils.isMobile(context)
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              // HRV Chart
                              _buildAnimatedCard(
                                child: _buildChart(
                                  data: controller.hrvPoints,
                                  title: 'Heart Rate Variability (HRV)',
                                  unit: 'ms',
                                  color: AppTheme.hrvColor,
                                  selectedPoint: controller.selectedPoint,
                                  rollingMean: controller.hrvRollingMean,
                                  stdDev: controller.hrvStdDev,
                                  showBands: true,
                                ),
                              ),

                              // RHR Chart
                              _buildAnimatedCard(
                                child: _buildChart(
                                  data: controller.rhrPoints,
                                  title: 'Resting Heart Rate (RHR)',
                                  unit: 'bpm',
                                  color: AppTheme.rhrColor,
                                  selectedPoint: controller.selectedPoint,
                                ),
                              ),

                              // Steps Chart
                              _buildAnimatedCard(
                                child: _buildChart(
                                  data: controller.stepsPoints,
                                  title: 'Daily Steps',
                                  unit: 'steps',
                                  color: AppTheme.stepsColor,
                                  selectedPoint: controller.selectedPoint,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: ResponsiveUtils.getGridColumns(
                            context,
                          ),
                          childAspectRatio: ResponsiveUtils.isTablet(context)
                              ? 1.2
                              : 1.0,
                          padding: EdgeInsets.all(
                            ResponsiveUtils.getResponsivePadding(context),
                          ),
                          children: [
                            // HRV Chart
                            _buildAnimatedCard(
                              child: _buildChart(
                                data: controller.hrvPoints,
                                title: 'Heart Rate Variability (HRV)',
                                unit: 'ms',
                                color: AppTheme.hrvColor,
                                selectedPoint: controller.selectedPoint,
                                rollingMean: controller.hrvRollingMean,
                                stdDev: controller.hrvStdDev,
                                showBands: true,
                              ),
                            ),

                            // RHR Chart
                            _buildAnimatedCard(
                              child: _buildChart(
                                data: controller.rhrPoints,
                                title: 'Resting Heart Rate (RHR)',
                                unit: 'bpm',
                                color: AppTheme.rhrColor,
                                selectedPoint: controller.selectedPoint,
                              ),
                            ),

                            // Steps Chart
                            _buildAnimatedCard(
                              child: _buildChart(
                                data: controller.stepsPoints,
                                title: 'Daily Steps',
                                unit: 'steps',
                                color: AppTheme.stepsColor,
                                selectedPoint: controller.selectedPoint,
                              ),
                            ),
                          ],
                        ),
                ),

                // Tooltip overlay
                if (controller.selectedPoint != null)
                  TooltipOverlay(
                    selectedPoint: controller.selectedPoint!,
                    journalEntries: controller.getJournalEntriesForDate(
                      controller.selectedPoint!.date,
                    ),
                    onClose: () => controller.updateSelectedPoint(null),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return AnimatedContainer(
      duration: ResponsiveUtils.getAnimationDuration(context),
      margin: EdgeInsets.all(ResponsiveUtils.getResponsiveMargin(context)),
      child: Card(
        elevation: ResponsiveUtils.isMobile(context) ? 2 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.isMobile(context) ? 12 : 16,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildChart({
    required List<ChartDataPoint> data,
    required String title,
    required String unit,
    required Color color,
    ChartDataPoint? selectedPoint,
    List<ChartDataPoint>? rollingMean,
    List<double>? stdDev,
    bool showBands = false,
  }) {
    try {
      // Final safety check for data
      if (data.isEmpty) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: const Center(child: Text('No data available')),
        );
      }

      switch (_selectedChartType) {
        case AppConstants.barChart:
          return BarChartWidget(
            data: data,
            title: title,
            unit: unit,
            color: color,
          );
        case AppConstants.pieChart:
          return PieChartWidget(data: data, title: title);
        default:
          return BaseChart(
            data: data,
            title: title,
            unit: unit,
            color: color,
            selectedPoint: selectedPoint,
            rollingMean: rollingMean,
            stdDev: stdDev,
            showBands: showBands,
          );
      }
    } catch (e) {
      // Fallback widget if chart creation fails
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Chart Error',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unable to display chart data',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
  }

  IconData _getChartTypeIcon(String chartType) {
    switch (chartType) {
      case AppConstants.lineChart:
        return LucideIcons.trendingUp;
      case AppConstants.barChart:
        return LucideIcons.barChart3;
      case AppConstants.pieChart:
        return LucideIcons.pieChart;
      default:
        return LucideIcons.trendingUp;
    }
  }

  String _getChartTypeName(String chartType) {
    switch (chartType) {
      case AppConstants.lineChart:
        return 'Line';
      case AppConstants.barChart:
        return 'Bar';
      case AppConstants.pieChart:
        return 'Pie';
      default:
        return 'Line';
    }
  }
}
