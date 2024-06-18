import 'package:flutter/material.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Color(0xFF545D68),
          ),
        ),
      ),
    );
  }
}
