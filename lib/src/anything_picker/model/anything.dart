import 'dart:convert';
import 'package:anything_picker/src/azlistview_plus/azlistview_plus.dart';

class Anything extends ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  final String code;
  final String text;
  final String? subtext;
  final dynamic extra;

  /// 당신이 넣고 싶은 데이터

  Anything(this.code, this.text, {this.subtext, this.extra});

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() {
    return json.encode(this);
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'text': text,
        'subtext': subtext,
        'extra': extra,
      };

  Anything copyWith({
    String? code,
    String? text,
    String? subtext,
    dynamic extra,
  }) {
    final anything = Anything(
      code ?? this.code,
      text ?? this.text,
      subtext: subtext ?? this.subtext,
      extra: extra ?? this.extra,
    );
    anything.tagIndex = tagIndex;
    anything.pinyin = pinyin;
    anything.shortPinyin = shortPinyin;
    return anything;
  }
}
