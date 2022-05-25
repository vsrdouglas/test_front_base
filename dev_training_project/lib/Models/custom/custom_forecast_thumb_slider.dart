// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForecastRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  final RangeValues value;
  final double forecast;
  final double current;

  const ForecastRangeSliderThumbShape({
    required this.value,
    required this.current,
    required this.forecast,
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  }) : assert(enabledThumbRadius != null);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(context != null);
    assert(center != null);
    assert(activationAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    assert(enableAnimation != null);
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final ColorTween forecastColorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: Colors.amber,
    );

    final double radius = radiusTween.evaluate(enableAnimation);
    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    if (isOnTop == true) {
      final Paint strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final Color color;
    if ((forecast != 0) && (thumb == Thumb.end && value.end > current) ||
        (thumb == Thumb.start && value.start > current)) {
      color = forecastColorTween.evaluate(enableAnimation)!;
    } else {
      color = colorTween.evaluate(enableAnimation)!;
    }

    final double evaluatedElevation =
        isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final Path shadowPath = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          math.pi * 2);
    canvas.drawShadow(shadowPath, Colors.black, evaluatedElevation, true);

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}
