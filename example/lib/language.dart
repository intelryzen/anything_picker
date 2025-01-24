import 'dart:convert';

import 'package:example/azlistview_plus/azlistview_plus.dart';

class Language extends ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  final String text;

  Language(this.text);

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() {
    return json.encode(this);
  }

  Map<String, dynamic> toJson() => {'text': text};
}

// class Languages extends Language implements ISuspensionBean {
//   String? tagIndex;
//   String? pinyin;
//   String? shortPinyin;
//   Languages(String text) : super(text);
//
//   @override
//   String getSuspensionTag() => tagIndex!;
//
//   @override
//   String toString() => json.encode(this);
// }
