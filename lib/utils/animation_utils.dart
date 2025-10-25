import 'package:flutter/material.dart';

class AnimationUtils {
  // Common animation durations
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 600);
  static const Duration verySlowDuration = Duration(milliseconds: 800);

  // Common animation curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;

  // Common animation builders
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(scale: animation, child: child);
  }

  static Widget slideTransition({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return SlideTransition(position: animation, child: child);
  }

  // Common animation controllers
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = mediumDuration,
  }) {
    return AnimationController(duration: duration, vsync: vsync);
  }

  // Common tween animations
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: easeInOut));
  }

  static Animation<double> createScaleAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: elasticOut));
  }

  static Animation<Offset> createSlideAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: easeInOut));
  }
}
