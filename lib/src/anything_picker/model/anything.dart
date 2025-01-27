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

  // 정렬 기준
  final String? sortingKey;

  Anything(this.code, this.text, {this.subtext, this.extra, this.sortingKey});

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
    String? tagIndex,
    String? pinyin,
    String? shortPinyin,
  }) {
    final anything = Anything(
      code ?? this.code,
      text ?? this.text,
      subtext: subtext ?? this.subtext,
      extra: extra ?? this.extra,
      sortingKey: sortingKey,
    );
    anything.tagIndex = tagIndex ?? this.tagIndex;
    anything.pinyin = pinyin ?? this.pinyin;
    anything.shortPinyin = shortPinyin ?? this.shortPinyin;
    return anything;
  }
}
