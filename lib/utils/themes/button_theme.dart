import 'package:flutter/material.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class AppButtonThemes {
  /// Filled button theme for Light Mode - black buttons
  static FilledButtonThemeData lightFilled = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white, 
    ),
  );

  /// Filled button theme for Dark Mode - blue buttons
  static FilledButtonThemeData darkFilled = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: MyColors.brightBlue, 
      foregroundColor: Colors.white,
    ),
  );
}
