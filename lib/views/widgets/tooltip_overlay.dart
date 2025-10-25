import 'package:flutter/material.dart';
import '../../model/chart_data.dart';
import '../../model/biometrics_data.dart';
import '../../utils/color_utils.dart';

class TooltipOverlay extends StatelessWidget {
  final ChartDataPoint selectedPoint;
  final List<JournalEntry> journalEntries;
  final VoidCallback onClose;

  const TooltipOverlay({
    super.key,
    required this.selectedPoint,
    required this.journalEntries,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data for ${_formatDate(selectedPoint.date)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Value: ${_formatValue(selectedPoint.y)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (journalEntries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Journal Entries:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...journalEntries.map(
              (entry) => _buildJournalEntry(context, entry),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJournalEntry(BuildContext context, JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorUtils.withMediumOpacity(
          ColorUtils.getPrimaryContainerColor(context),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(_getMoodEmoji(entry.mood), style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.note, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  'Mood: ${entry.mood}/5',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorUtils.withHighOpacity(
                      ColorUtils.getOnSurfaceColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }
}
