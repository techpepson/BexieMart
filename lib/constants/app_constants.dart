import 'dart:ui';

import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Bexie Mart";
  static const String appVersion = "1.0.0";
  static const String appDescription =
      "Bexie Mart is an online retail app store for people to upload and sell their products, as well as buy from other people.";
  static const String appLogo = "assets/images/appLogo.jpg";

  //app colors
  static const Color primaryColor = Color(0xFF0000FF);
  static const Color secondaryColor = Color(0xFFADD8E6);
  static const Color accentColor = Color(0xFFCD853F);
  static const Color textColor = Color(0xFF002E63);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB3261E);

  //icons
  static const IconData checkedCircleIcon = Icons.check_circle_outline_outlined;
  static const IconData forwardArrowIcon = Icons.arrow_forward_outlined;
  static const IconData backArrowIcon = Icons.arrow_back;
  static const IconData errorIcon = Icons.error_outline;

  //font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;

  //font weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w600;

  //font family
  static const String fontFamilyRaleway = "Raleway";
  static const String fontFamilyNunito = "Nunito";

  //font styles
  static const FontStyle fontStyleNormal = FontStyle.normal;
  static const FontStyle fontStyleItalic = FontStyle.italic;

  //images
  static const String forgotPasswordImage = "assets/images/forgot_pass.jpg";
  static const String onboardSmallImage1 = "assets/images/image.png";
  static const String onboardLargeImage1 = "assets/images/Image@2x.png";
  static const String onboardSmallImage2 = "assets/images/Placeholder_01.png";
  static const String onboardLargeImage2 =
      "assets/images/Placeholder_01@2x.png";
}
