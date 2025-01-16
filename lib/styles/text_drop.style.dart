import 'package:flutter/material.dart';

class TextDropStyle {
  final int? maxLines;
  final TextOverflow overflow;
  final FontWeight fontWeight;
  final double fontSize;
  final Color? textColor;

  const TextDropStyle({
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,
    this.textColor,
  });
}
