import 'package:flutter/material.dart';

import 'package:friendfit_ready/theme/colors/light_colors.dart';

class TopContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsets? padding;
  TopContainer({this.height, this.width, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding != null ? padding : EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: Colors.white
          /* borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )*/
          ),
      height: height,
      width: width,
      child: child,
    );
  }
}
