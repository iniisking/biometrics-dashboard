import 'package:flutter/material.dart';

class ColorUtils {
  // Common opacity values used throughout the app
  static const double lightOpacity = 0.1;
  static const double mediumOpacity = 0.3;
  static const double highOpacity = 0.7;
  static const double borderOpacity = 0.2;

  // Helper methods for common color operations
  static Color withLightOpacity(Color color) =>
      color.withValues(alpha: lightOpacity);
  static Color withMediumOpacity(Color color) =>
      color.withValues(alpha: mediumOpacity);
  static Color withHighOpacity(Color color) =>
      color.withValues(alpha: highOpacity);
  static Color withBorderOpacity(Color color) =>
      color.withValues(alpha: borderOpacity);

  // Theme-aware color helpers
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getOnSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getPrimaryContainerColor(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color getOutlineColor(BuildContext context) {
    return Theme.of(context).colorScheme.outline;
  }

  // Common color combinations
  static Color getShimmerBaseColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[300]!;
  }

  static Color getShimmerHighlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[100]!;
  }
}
