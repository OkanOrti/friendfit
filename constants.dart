import 'package:flutter/material.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

const kPrimaryColor = Color(0xFF3E4067);
const kTextColor = Color(0xFF3F4168);
const kIconColor = Color(0xFF5E5E5E);

const kDefaultPadding = 20.0;
const adminId = "Tsoks9zBTNc0K75HNH6tzb99rmU2";
const maxSteps = 20000;
const minStep = 0;
const dividerSteps = 5000;

final kDefualtShadow = BoxShadow(
  offset: Offset(5, 5),
  blurRadius: 10,
  color: Color(0xFFE9E9E9).withOpacity(0.56),
);

final kDefualtShadow2 = BoxShadow(
  offset: Offset(-5, 5),
  blurRadius: 10,
  color: Color(0xFFE9E9E9).withOpacity(0.56),
);

final kDefualtShadow3 = BoxShadow(
  offset: Offset(5, 0),
  blurRadius: 10,
  color: Color(0xFFE9E9E9).withOpacity(0.56),
);
final kHintTextStyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: AppColors.kRipple.withOpacity(0.5),
  borderRadius: BorderRadius.circular(10.0),
);
