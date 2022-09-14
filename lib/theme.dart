import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: textTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: accentColor,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    foregroundColor: secondaryColor,
    side: const BorderSide(color: secondaryColor),
  )),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: secondaryColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent),
);

// TEXT THEME
TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 34,
      fontWeight: FontWeight.bold,
    ),
  ),
  headline2: GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
  bodyText1: GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  bodyText2: GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  ),
);
