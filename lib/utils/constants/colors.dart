import 'package:flutter/material.dart';


class TColors{
  TColors._();


  //App Basic Colors
  static const Color primary = Color(0xff874bff);
  static const Color secondary = Color(0xFF5000E8);
  static const Color accent = Color(0xff80c0f1);

  //Gradient colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xFFFF9A9A),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ]
  );

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;

  //BG color
  static const Color light = Color(0xfff6f6f6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xfff3f5ff);

  //BG Container
  static const Color lightContainer = Color(0xfff6f6f6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  //button colors
  static const Color buttonPrimary = Color(0xff874bff);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xffc4c4c4);

//   Border colors
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

//   Errors and validations
  static const Color error = Color(0xffd32f2f);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xfff57c00);
  static const Color info = Color(0xff874bff);

//   Neutral shades
  static const Color black = Color(0xff232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);



}