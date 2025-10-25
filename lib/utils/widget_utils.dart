import 'package:flutter/material.dart';
import 'color_utils.dart';

class WidgetUtils {
  // Common spacing values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Common border radius values
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;

  // Common elevation values
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Common padding values
  static const EdgeInsets paddingS = EdgeInsets.all(spacingS);
  static const EdgeInsets paddingM = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingL = EdgeInsets.all(spacingL);

  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(
    horizontal: spacingM,
  );
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(
    vertical: spacingM,
  );

  // Common container decorations
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorUtils.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(radiusM),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration shimmerDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorUtils.getShimmerBaseColor(context),
      borderRadius: BorderRadius.circular(radiusS),
    );
  }

  // Common text styles
  static TextStyle? titleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle? bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? captionStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
      color: ColorUtils.getOnSurfaceColor(context).withValues(alpha: 0.7),
    );
  }

  // Common button styles
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: spacingL,
        vertical: spacingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      elevation: elevationS,
    );
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: ColorUtils.getOnSurfaceColor(context),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingL,
        vertical: spacingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      elevation: 0,
    );
  }
}
