import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CupertinoPalette {
  static const Color text = CupertinoColors.black;
  static const Color primary = CupertinoColors.systemBlue;

  static const Color background = Color(0xfff2f2f6);
  static const Color scrolledAppBarColor = Color(0xfffafafd);
  static const Color textFieldBackground = Color(0xffe3e3e8);
  static const Color textFieldIconColor = Color(0xff828186);

  static const Color susTextColor = Color(0xFF666666);

  static const Color itemColor = Color(0xffffffff);
  static const Color dividerColor = Color(0xffc6c6c8);

  static Color indexHintColor = Colors.black.withValues(alpha: .4);
  static Color indexHintText = Colors.white;
}

abstract class CupertinoDarkPalette {
  static const Color text = CupertinoColors.white;
  static const Color primary = Color(0xff0b84ff);

  static const Color background = Color(0xff1c1c1e);
  static const Color scrolledAppBarColor = Color(0xff282928);
  static const Color textFieldBackground = Color(0xff3b3c3e);
  static const Color textFieldIconColor = Color(0xffa5a6ac);

  static const Color susTextColor = Color(0xFF98989f);

  static const Color itemColor = Color(0xff2c2c2e);
  static const Color dividerColor = Color(0xff444447);

  static Color indexHintColor = Colors.white.withValues(alpha: .55);
  static Color indexHintText = Colors.black;
}

abstract class CupertinoUtil {
  static bool _isDark(context) =>
      Theme.of(context).brightness == Brightness.light;

  static Color text(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.text;
    } else {
      return CupertinoPalette.text;
    }
  }

  static Color primary(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.primary;
    } else {
      return CupertinoPalette.primary;
    }
  }

  static Color background(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.background;
    } else {
      return CupertinoPalette.background;
    }
  }

  static Color scrolledAppBarColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.scrolledAppBarColor;
    } else {
      return CupertinoPalette.scrolledAppBarColor;
    }
  }

  static Color textFieldBackground(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.textFieldBackground;
    } else {
      return CupertinoPalette.textFieldBackground;
    }
  }

  static Color textFieldIconColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.textFieldIconColor;
    } else {
      return CupertinoPalette.textFieldIconColor;
    }
  }

  static Color susTextColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.susTextColor;
    } else {
      return CupertinoPalette.susTextColor;
    }
  }

  static Color itemColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.itemColor;
    } else {
      return CupertinoPalette.itemColor;
    }
  }

  static Color dividerColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.dividerColor;
    } else {
      return CupertinoPalette.dividerColor;
    }
  }

  static Color indexHintColor(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.indexHintColor;
    } else {
      return CupertinoPalette.indexHintColor;
    }
  }

  static Color indexHintText(context) {
    if (_isDark(context)) {
      return CupertinoDarkPalette.indexHintText;
    } else {
      return CupertinoPalette.indexHintText;
    }
  }

}
