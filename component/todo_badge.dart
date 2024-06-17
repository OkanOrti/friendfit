import 'package:flutter/material.dart';
import 'package:friendfit_ready/data/choice_card.dart';

class TodoBadge extends StatelessWidget {
  final Choice? codePoint;
  final Color? color;
  final String? id;
  final double? size;
  final Color outlineColor;

  TodoBadge({
    this.codePoint,
    @required this.color,
    this.id,
    Color? outlineColor,
    this.size,
  }) : outlineColor = outlineColor ?? Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: outlineColor,
          ),
        ),
        child: codePoint!.image!);
  }
}
