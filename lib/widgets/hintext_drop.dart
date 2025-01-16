import 'package:flutter/material.dart';
import 'package:quanht_auto_dropper/config/config.index.dart';
import 'package:quanht_auto_dropper/styles/text_drop.style.dart';

class HintextDrop extends StatelessWidget {
  final String hintText;
  final TextDropStyle hintTextStyle;
  const HintextDrop(
      {super.key,
      required this.hintText,
      this.hintTextStyle = const TextDropStyle()});

  @override
  Widget build(BuildContext context) {
    return _hintTextWidget(context);
  }

  Widget _hintTextWidget(BuildContext context) {
    return Row(
      children: [
        Text(
          hintText,
          maxLines: hintTextStyle.maxLines,
          overflow: hintTextStyle.overflow,
          style: TextStyle(
              fontWeight: hintTextStyle.fontWeight,
              fontSize: hintTextStyle.fontSize,
              color: (hintTextStyle.textColor ?? Colors.black).toOpacity(0.6)),
        ),
      ],
    );
  }
}
