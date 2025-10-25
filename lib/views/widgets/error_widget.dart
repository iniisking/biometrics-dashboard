import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/app_theme.dart';
import '../../utils/color_utils.dart';
import '../../utils/widget_utils.dart';
import '../../utils/animation_utils.dart';

class ErrorWidget extends StatefulWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorWidget({super.key, required this.error, required this.onRetry});

  @override
  State<ErrorWidget> createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationUtils.createController(
      vsync: this,
      duration: AnimationUtils.verySlowDuration,
    );

    _scaleAnimation = AnimationUtils.createScaleAnimation(_animationController);
    _fadeAnimation = AnimationUtils.createFadeAnimation(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated error illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: AppTheme.errorGradient,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryRed.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.alertTriangle,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Error title
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Error message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? ColorUtils.withLightOpacity(Colors.red)
                            : ColorUtils.withLightOpacity(Colors.red),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorUtils.withBorderOpacity(Colors.red),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.error,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.red[300] : Colors.red[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Retry button with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add haptic feedback
                          _animationController.reset();
                          _animationController.forward();
                          widget.onRetry();
                        },
                        icon: const Icon(LucideIcons.refreshCw),
                        label: const Text('Try Again'),
                        style: WidgetUtils.primaryButtonStyle(context),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional help text
                    Text(
                      'Check your connection and try again',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
