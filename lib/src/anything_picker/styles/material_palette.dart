import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class MaterialPalette {
  static const Color text = CupertinoColors.black;
  static const Color primary = CupertinoColors.systemBlue;

  static const Color background = Color(0xfff1f1f3);
  static const Color scrolledAppBarColor = Color(0xfffafafd);
  static const Color appBarDivider =  Color(0xffadaead);
  static const Color textFieldBackground = Color(0xffe3e3e8);
  static const Color textFieldIconColor = Color(0xff828186);

  static const Color susTextColor = Color(0xFF666666);

  static const Color itemColor = Color(0xffffffff);
  static const Color dividerColor = Color(0xffc6c6c8);

  static Color indexHintColor = Colors.black.withValues(alpha: .4);
  static Color indexHintText = Colors.white;
}

abstract class MaterialDarkPalette {
  static const Color text = CupertinoColors.white;
  static const Color primary = Color(0xff0b84ff);

  static const Color background = Color(0xff1c1c1e);
  static const Color scrolledAppBarColor = Color(0xff282928);
  static const Color appBarDivider = Color(0xff4c4c4d);
  static const Color textFieldBackground = Color(0xff3b3c3e);
  static const Color textFieldIconColor = Color(0xffa5a6ac);

  static const Color susTextColor = Color(0xFF98989f);

  static const Color itemColor = Color(0xff2c2c2e);
  static const Color dividerColor = Color(0xff444447);

  static Color indexHintColor = Colors.white.withValues(alpha: .55);
  static Color indexHintText = Colors.black;
}

abstract class MaterialPaletteUtil {
  static bool _isDark(context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color text(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.text;
    } else {
      return MaterialPalette.text;
    }
  }

  static Color primary(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.primary;
    } else {
      return MaterialPalette.primary;
    }
  }

  static Color background(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.background;
    } else {
      return MaterialPalette.background;
    }
  }

  static Color scrolledAppBarColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.scrolledAppBarColor;
    } else {
      return MaterialPalette.scrolledAppBarColor;
    }
  }

  static Color appBarDivider(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.appBarDivider;
    } else {
      return MaterialPalette.appBarDivider;
    }
  }

  static Color textFieldBackground(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.textFieldBackground;
    } else {
      return MaterialPalette.textFieldBackground;
    }
  }

  static Color textFieldIconColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.textFieldIconColor;
    } else {
      return MaterialPalette.textFieldIconColor;
    }
  }

  static Color susTextColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.susTextColor;
    } else {
      return MaterialPalette.susTextColor;
    }
  }

  static Color itemColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.itemColor;
    } else {
      return MaterialPalette.itemColor;
    }
  }

  static Color dividerColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.dividerColor;
    } else {
      return MaterialPalette.dividerColor;
    }
  }

  static Color indexHintColor(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.indexHintColor;
    } else {
      return MaterialPalette.indexHintColor;
    }
  }

  static Color indexHintText(context) {
    if (_isDark(context)) {
      return MaterialDarkPalette.indexHintText;
    } else {
      return MaterialPalette.indexHintText;
    }
  }
}
