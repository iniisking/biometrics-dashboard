import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/color_utils.dart';
import '../../utils/widget_utils.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _breathController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for overall shimmer intensity
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Wave animation for flowing shimmer effect
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Breathing animation for subtle movement
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Start animations
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header shimmer with enhanced effects
          _buildHeaderShimmer(context),

          // Range selector shimmer
          _buildRangeSelectorShimmer(context),

          // Charts shimmer with staggered animations
          ...List.generate(3, (index) => _buildChartShimmer(context, index)),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _breathAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: ColorUtils.getShimmerBaseColor(context),
              highlightColor: ColorUtils.getShimmerHighlightColor(
                context,
              ).withValues(alpha: _pulseAnimation.value),
              period: const Duration(milliseconds: 1200),
              direction: ShimmerDirection.ltr,
              child: Row(
                children: [
                  // Animated title with gradient effect
                  Container(
                    width: 200,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(WidgetUtils.radiusM),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Animated subtitle
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(WidgetUtils.radiusS),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Animated icon with pulse effect
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                          Colors.grey[400]!,
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRangeSelectorShimmer(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: ColorUtils.getShimmerBaseColor(context),
            highlightColor: ColorUtils.getShimmerHighlightColor(context),
            period: const Duration(milliseconds: 1000),
            direction: ShimmerDirection.ltr,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[200]!,
                    Colors.grey[100]!,
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(WidgetUtils.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 70,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                        ],
                        stops: [0.0, 0.5 + (_waveAnimation.value * 0.3), 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(WidgetUtils.radiusM),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartShimmer(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _waveAnimation,
        _breathAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: ColorUtils.getShimmerBaseColor(context),
              highlightColor: ColorUtils.getShimmerHighlightColor(
                context,
              ).withValues(alpha: _pulseAnimation.value),
              period: Duration(
                milliseconds: 1200 + (index * 300),
              ), // Staggered animation
              direction: ShimmerDirection.ltr,
              child: Card(
                elevation: WidgetUtils.elevationM + 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WidgetUtils.radiusL),
                ),
                child: Container(
                  height: 320,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[50]!,
                        Colors.grey[100]!,
                        Colors.grey[50]!,
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(WidgetUtils.radiusL),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced title with animated icon
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(
                                milliseconds: 500 + (index * 200),
                              ),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.grey[200]!,
                                    Colors.grey[300]!,
                                    Colors.grey[400]!,
                                  ],
                                  stops: [0.0, 0.7, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                      Colors.grey[300]!,
                                    ],
                                    stops: [
                                      0.0,
                                      0.5 + (_waveAnimation.value * 0.3),
                                      1.0,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Enhanced chart area with animated data points
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey[50]!,
                                  Colors.grey[100]!,
                                  Colors.grey[50]!,
                                ],
                                stops: [0.0, 0.5, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(
                                WidgetUtils.radiusM,
                              ),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Animated chart with realistic data visualization
                                  Expanded(
                                    child: CustomPaint(
                                      painter: _AnimatedChartPainter(
                                        animation: _waveAnimation,
                                        index: index,
                                      ),
                                      child: Container(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Animated axis labels
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      5,
                                      (i) => AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 200 + (i * 100),
                                        ),
                                        width: 30,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.grey[300]!,
                                              Colors.grey[200]!,
                                              Colors.grey[300]!,
                                            ],
                                            stops: [
                                              0.0,
                                              0.5 +
                                                  (_waveAnimation.value * 0.2),
                                              1.0,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Enhanced stats row with animated values
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                      Colors.grey[300]!,
                                    ],
                                    stops: [
                                      0.0,
                                      0.5 + (_waveAnimation.value * 0.3),
                                      1.0,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 80,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[200]!,
                                    Colors.grey[300]!,
                                  ],
                                  stops: [
                                    0.0,
                                    0.5 + (_waveAnimation.value * 0.3),
                                    1.0,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;

  const ShimmerCard({super.key, required this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}

class _AnimatedChartPainter extends CustomPainter {
  final Animation<double> animation;
  final int index;

  _AnimatedChartPainter({required this.animation, required this.index})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey[300]!;

    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey[200]!;

    // Create animated data points that look like a real chart
    final dataPoints = _generateDataPoints(size, index);

    // Draw animated bars/columns
    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final animatedHeight = point.height * (0.3 + (animation.value * 0.7));
      final animatedOpacity = 0.4 + (animation.value * 0.6);

      // Create gradient effect
      final rect = Rect.fromLTWH(
        point.x,
        size.height - animatedHeight,
        point.width,
        animatedHeight,
      );

      // Animated gradient
      final gradient = LinearGradient(
        colors: [
          Colors.grey[300]!.withValues(alpha: animatedOpacity),
          Colors.grey[200]!.withValues(alpha: animatedOpacity * 0.8),
          Colors.grey[300]!.withValues(alpha: animatedOpacity),
        ],
        stops: [0.0, 0.5 + (animation.value * 0.3), 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

      final shader = gradient.createShader(rect);
      paint.shader = shader;

      // Add rounded corners
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

      canvas.drawRRect(rrect, paint);

      // Add subtle highlight
      if (animation.value > 0.5) {
        final highlightRect = Rect.fromLTWH(
          point.x,
          size.height - animatedHeight,
          point.width,
          animatedHeight * 0.3,
        );

        final highlightGradient = LinearGradient(
          colors: [
            Colors.grey[100]!.withValues(alpha: 0.6),
            Colors.grey[200]!.withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

        final highlightShader = highlightGradient.createShader(highlightRect);
        highlightPaint.shader = highlightShader;

        final highlightRRect = RRect.fromRectAndRadius(
          highlightRect,
          const Radius.circular(4),
        );

        canvas.drawRRect(highlightRRect, highlightPaint);
      }
    }

    // Add animated connection lines between points
    if (animation.value > 0.3) {
      _drawConnectionLines(canvas, dataPoints, size, animation.value);
    }
  }

  List<_DataPoint> _generateDataPoints(Size size, int chartIndex) {
    final points = <_DataPoint>[];
    final barWidth = (size.width - 40) / 12; // 12 bars with spacing
    final maxHeight = size.height * 0.8;

    for (int i = 0; i < 12; i++) {
      // Create realistic data patterns based on chart index
      double heightMultiplier;
      switch (chartIndex) {
        case 0: // HRV - more variable
          heightMultiplier = 0.3 + (i % 3) * 0.2 + (i % 2) * 0.1;
          break;
        case 1: // RHR - more stable
          heightMultiplier = 0.4 + (i % 2) * 0.15;
          break;
        case 2: // Steps - more varied
          heightMultiplier = 0.2 + (i % 4) * 0.2;
          break;
        default:
          heightMultiplier = 0.3 + (i % 3) * 0.2;
      }

      points.add(
        _DataPoint(
          x: 20 + (i * barWidth),
          y: 0,
          width: barWidth * 0.8,
          height: maxHeight * heightMultiplier,
        ),
      );
    }

    return points;
  }

  void _drawConnectionLines(
    Canvas canvas,
    List<_DataPoint> points,
    Size size,
    double animationValue,
  ) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.grey[400]!.withValues(alpha: animationValue * 0.6);

    final path = Path();

    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];

      final currentY =
          size.height - (currentPoint.height * (0.3 + (animationValue * 0.7)));
      final nextY =
          size.height - (nextPoint.height * (0.3 + (animationValue * 0.7)));

      final currentX = currentPoint.x + currentPoint.width / 2;
      final nextX = nextPoint.x + nextPoint.width / 2;

      if (i == 0) {
        path.moveTo(currentX, currentY);
      }

      path.lineTo(nextX, nextY);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _DataPoint {
  final double x;
  final double y;
  final double width;
  final double height;

  _DataPoint({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}
