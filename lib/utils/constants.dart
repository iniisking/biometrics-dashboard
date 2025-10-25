class AppConstants {
  // App metadata
  static const String appName = 'Biometrics Dashboard';
  static const String appVersion = '1.0.0';

  // Data service constants
  static const int minLatencyMs = 700;
  static const int maxLatencyMs = 1200;
  static const double failureRate = 0.1; // 10%

  // Chart constants
  static const int maxDataPoints = 10000;
  static const int defaultDataPoints = 100;

  // Date range constants
  static const int sevenDays = 7;
  static const int thirtyDays = 30;
  static const int ninetyDays = 90;

  // Chart type constants
  static const String lineChart = 'line';
  static const String barChart = 'bar';
  static const String areaChart = 'area';
  static const String pieChart = 'pie';

  // Animation durations
  static const int fastAnimationMs = 200;
  static const int mediumAnimationMs = 300;
  static const int slowAnimationMs = 600;
  static const int verySlowAnimationMs = 800;

  // Common values
  static const double defaultElevation = 2.0;
  static const double cardElevation = 4.0;
  static const double buttonElevation = 2.0;

  // Opacity values
  static const double lightOpacity = 0.1;
  static const double mediumOpacity = 0.3;
  static const double highOpacity = 0.7;
  static const double borderOpacity = 0.2;

  // Spacing values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border radius values
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
}
