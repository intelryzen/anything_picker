import 'dart:convert';
import 'package:anything_picker/src/azlistview_plus/azlistview_plus.dart';

class Anything extends ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  final String code;
  final String text;
  final String? subtext;

  Anything(this.code, this.text, {this.subtext});

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
      };

  Anything copyWith({
    String? code,
    String? text,
    String? subtext,
  }) {
    return Anything(
      code ?? this.code,
      text ?? this.text,
      subtext: this.subtext,
    );
  }
}
