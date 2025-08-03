import 'package:flutter/material.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class AppNavigationThemes {
  static NavigationBarThemeData light = NavigationBarThemeData(
    backgroundColor: MyColors.lightWhite,
    indicatorColor: MyColors.cyanBlue,

    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    ),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
      return const IconThemeData(color: MyColors.white);
      }
      return const IconThemeData(color: MyColors.mediumGray);
    }),
  );

  static NavigationBarThemeData dark = NavigationBarThemeData(
    backgroundColor: MyColors.lightBlack,
    indicatorColor: MyColors.cyanBlue,
    elevation: 8,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    iconTheme: WidgetStateProperty.all(
      const IconThemeData(color: MyColors.white),
    ),
  );
}
