import 'dart:convert';
import 'package:example/azlistview_plus/azlistview_plus.dart';

class AnythingData extends ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  final String code;
  final String text;
  final String? subtext;

  AnythingData(this.code, this.text, {this.subtext});

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

  AnythingData copyWith({
    String? code,
    String? text,
    String? subtext,
  }) {
    return AnythingData(
      code ?? this.code,
      text ?? this.text,
      subtext: this.subtext,
    );
  }
}
