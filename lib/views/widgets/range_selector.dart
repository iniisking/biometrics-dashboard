import 'package:flutter/material.dart';
import '../../model/chart_data.dart';
import '../../config/app_theme.dart';
import '../../utils/color_utils.dart';
import '../../utils/widget_utils.dart';
import '../../utils/animation_utils.dart';

class RangeSelector extends StatelessWidget {
  final DateRange selectedRange;
  final Function(DateRange) onRangeChanged;

  const RangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorUtils.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(WidgetUtils.radiusM),
        border: Border.all(
          color: ColorUtils.withBorderOpacity(
            ColorUtils.getOutlineColor(context),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: DateRange.values.map((range) {
          final isSelected = range == selectedRange;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedContainer(
              duration: AnimationUtils.fastDuration,
              child: ElevatedButton(
                onPressed: () => onRangeChanged(range),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppTheme.primaryBlue
                      : Colors.transparent,
                  foregroundColor: isSelected
                      ? Colors.white
                      : ColorUtils.getOnSurfaceColor(context),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WidgetUtils.radiusS),
                  ),
                  padding: WidgetUtils.paddingHorizontalM,
                ),
                child: Text(
                  range.displayName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
