import 'package:flutter/material.dart';

class AutoDropButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final ShapeBorder? shape;
  final double elevation;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final EdgeInsets padding;
  final BoxConstraints? constraints;
  final double? width;
  final double height;
  final double radius;
  final Color primaryColor;

  const AutoDropButtonStyle({
    this.boxShadow = const [
      BoxShadow(
        color: Color(0xFFCDE2FE),
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ],
    this.border,
    this.mainAxisAlignment,
    this.backgroundColor = Colors.white,
    this.primaryColor = Colors.black87,
    this.constraints,
    this.height = 50,
    this.radius = 8.0,
    this.width,
    this.elevation = 1,
    this.padding = EdgeInsets.zero,
    this.shape,
  });
}

class AutoDropStyle {
  final double elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Color? scrollbarColor;

  /// Add shape and border radius of the dropdown from here
  final ShapeBorder? shape;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const AutoDropStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation = 10,
    this.shape,
    this.color,
    this.padding,
    this.scrollbarColor,
  });
}
