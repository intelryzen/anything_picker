
import 'package:anything_picker/src/anything_picker/const/anything_picker_const.dart';

abstract class AnythingPickerUtil {
  static String getEnglishInitial(String text) {
    if (text.isEmpty) {
      return "#";
    }

    String initialText = text.substring(0, 1).toUpperCase();

    if (RegExp("[A-Z]").hasMatch(initialText)) {
      return initialText;
    } else {
      return "#";
    }
  }

  static String getKoreanInitial(String text) {
    if (text.isEmpty) {
      return "#";
    }

    // 쌍자음을 단일 자음으로 매핑
    const Map<String, String> doubleToSingle = {
      'ㄲ': 'ㄱ',
      'ㄸ': 'ㄷ',
      'ㅃ': 'ㅂ',
      'ㅆ': 'ㅅ',
      'ㅉ': 'ㅈ',
    };

    // 초성 추출 결과를 담을 리스트
    List<String> initials = [];

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      // 유니코드로 변환
      int codeUnit = char.codeUnitAt(0);

      // 한글 범위 체크 (가 ~ 힣)
      if (codeUnit >= 0xAC00 && codeUnit <= 0xD7A3) {
        // 초성 계산 공식
        int index = ((codeUnit - 0xAC00) ~/ 28) ~/ 21;
        print(index);
        print(text);
        String initial = indexBarKoreanData[index];

        // 쌍자음을 단일 자음으로 변환
        initials.add(doubleToSingle[initial] ?? initial);
      } else {
        // 한글이 아니면 원래 문자 그대로 추가
        initials.add("#");
      }
    }

    // 초성 문자열 반환
    return initials.join().substring(0, 1);
  }
}
