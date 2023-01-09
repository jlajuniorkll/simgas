import 'package:flutter/material.dart';

Map<int, Color> _swatchOpacity = {
  50: const Color.fromRGBO(253, 103, 2, .1),
  100: const Color.fromRGBO(253, 103, 2, .2),
  200: const Color.fromRGBO(253, 103, 2, .3),
  300: const Color.fromRGBO(253, 103, 2, .4),
  400: const Color.fromRGBO(253, 103, 2, .5),
  500: const Color.fromRGBO(253, 103, 2, .6),
  600: const Color.fromRGBO(253, 103, 2, .7),
  700: const Color.fromRGBO(253, 103, 2, .8),
  800: const Color.fromRGBO(253, 103, 2, .9),
  900: const Color.fromRGBO(253, 103, 2, 1),
};

abstract class CustomColors {
  static Color customContrastColor = const Color(0xFFD32F2F);
  static MaterialColor customSwatchColor =
      MaterialColor(0xFFFD6702, _swatchOpacity);
}

final colorPrimaryClient = MaterialColor(0xFFFD6702, _swatchOpacity);
const colorSelectedClient = Colors.white;
final colorUnSelectedClient = Colors.white.withAlpha(100);
