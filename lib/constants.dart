import 'package:flutter/material.dart';

final int kMyVersion = 1;
final int kMinimumVersionIfError = 9999;

const double kDefaultMargin = 25.0;
const double kDefaultPadding = 25.0;

const kPrimaryColor = Color(0xff3092C3);
const kSecondaryColor = Color(0xff797979);
const kBlack = Color(0xff555555);
const kGrey = Color(0xffcccccc);
const kGreyLight = Color(0xffe2e2e2);
const kBlueCupertino = Color(0xff3092C3);
const kGreyCupertino = Color(0xff717071);

const kBackgroundColor = Color(0xFFF2F3F7);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
