import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    inputDecorationTheme: inputDecorationTheme(),
    outlinedButtonTheme: outlinedButtonTheme,
  );
}

final outlinedButtonTheme =
    OutlinedButtonThemeData(style: OutlinedButton.styleFrom());

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: kGrey,
    ),
    gapPadding: 10,
  );
  OutlineInputBorder focusOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: kPrimaryColor,
    ),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    labelStyle: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: kSecondaryColor),
    hintStyle: TextStyle(color: kGrey),
    enabledBorder: outlineInputBorder,
    focusedBorder: focusOutlineInputBorder,
    border: outlineInputBorder,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  );
}
