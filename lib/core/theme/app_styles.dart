import 'package:flutter/material.dart';
import '../../data/model/city_model.dart';
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

final BoxDecoration roundedDecorationWithShadow =BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color:horlyrow .withOpacity(0.7),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.2), // Shadow color
      spreadRadius: 2, // How much the shadow spreads
      blurRadius: 6, // How soft the shadow is
      offset: Offset(4, 4), // x, y: move right & down
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
BoxDecoration roundedWithGradient(Malta city) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: city.isFavorite
        ? Border.all(color: Colors.white, width: 2)
        : null,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        bgPrimary,
        bgSecondary,
        bgDark,
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 6,
        offset: const Offset(4, 4),
      ),
    ],
  );
}
final BoxDecoration roundedGreenBorderDecoration = BoxDecoration(
  color: greenColor.withValues(alpha: 0.3),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: greenColor,
    width: 1.0,
  ),
);
final BoxDecoration bgwithgradent =BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDark2, bgDark, bgPrimary, bgSecondary],
  ),
);
final BoxDecoration rounderGreyBorderDecoration = BoxDecoration(
  color: kWhite,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: greyBorderColor,
  ),
);
final BoxDecoration imagebg=BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/weather6.png"),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      Color(0xFF00A67D).withOpacity(0.68),
      BlendMode.srcOver,
    ),
  ),
);
final boxShadow = BoxShadow(
  color: Colors.grey.withValues(alpha: 0.2),
  blurRadius: 6,
  offset: Offset(0, 2),
);
