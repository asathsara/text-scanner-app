// lib/themes.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class AppThemes {
  AppThemes._(); // private constructor


  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor, brightness: Brightness.light),
    textTheme: GoogleFonts.lexendTextTheme(),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor, brightness: Brightness.dark),
    textTheme: GoogleFonts.lexendTextTheme(),
  );
}
