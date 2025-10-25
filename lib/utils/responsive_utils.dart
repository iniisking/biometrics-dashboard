import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Screen size helpers
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  // Responsive spacing
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  static double getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) return baseSize * 0.9;
    if (isTablet(context)) return baseSize;
    return baseSize * 1.1;
  }

  // Responsive chart heights
  static double getChartHeight(BuildContext context) {
    if (isMobile(context)) return 200.0;
    if (isTablet(context)) return 250.0;
    return 300.0;
  }

  // Responsive grid columns
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  // Responsive card width
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth - 32;
    if (isTablet(context)) return (screenWidth - 48) / 2;
    return (screenWidth - 64) / 3;
  }

  // Responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) return 56.0;
    return 64.0;
  }

  // Responsive button sizes
  static Size getButtonSize(BuildContext context) {
    if (isMobile(context)) return const Size(120, 40);
    if (isTablet(context)) return const Size(140, 44);
    return const Size(160, 48);
  }

  // Responsive icon sizes
  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 24.0;
    return 28.0;
  }

  // Responsive chart data points
  static int getMaxDataPoints(BuildContext context) {
    if (isMobile(context)) return 50;
    if (isTablet(context)) return 100;
    return 200;
  }

  // Responsive animation durations
  static Duration getAnimationDuration(BuildContext context) {
    if (isMobile(context)) return const Duration(milliseconds: 200);
    return const Duration(milliseconds: 300);
  }
}
