import 'package:flutter/material.dart';
import '../constant/constant.dart';
import 'app_colors.dart';

const TextStyle headlineMediumStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: blackTextColor,
);
const TextStyle headlineSmallStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);

const TextStyle titleLargeStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 22,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);

const TextStyle titleMediumStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: blackTextColor);

const TextStyle titleSmallStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);

const TextStyle bodyLargeStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const TextStyle bodyMediumStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: blackTextColor,
);

const TextStyle bodySmallStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle labelMediumStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
const TextStyle labelSmallStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
//decoration

final BoxDecoration roundedDecorationWithShadow = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);
final BoxDecoration roundedDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);
final BoxDecoration roundedGreenBorderDecoration = BoxDecoration(
  color: greenColor.withValues(alpha: 0.3),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: greenColor,
    width: 1.0,
  ),
);

final BoxDecoration rounderGreyBorderDecoration = BoxDecoration(
  color: kWhite,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: greyBorderColor,
  ),
);

final boxShadow = BoxShadow(
  color: Colors.grey.withValues(alpha: 0.2),
  blurRadius: 6,
  offset: Offset(0, 2),
);
