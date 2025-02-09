abstract class AnythingPickerUtil {
  static final Map<String, dynamic> supportedLanguages = {
    "ko": getKoreanInitial,
    "en": getEnglishInitial,
  };

  /// Returns a mapping function based on the provided language code.
  /// If the language code is not supported, the default language's mapper is returned.
  static String Function(String) getSupportedMapper(String languageCode, [String defaultLanguageCode = "en"]) {
    // Try to get the function for the provided language code.
    final mapper = supportedLanguages[languageCode];
    if (mapper != null) {
      return mapper;
    }
    // Fallback to the default language code.
    final defaultMapper = supportedLanguages[defaultLanguageCode];
    if (defaultMapper != null) {
      return defaultMapper;
    }
    // If no mapper is found, you could either throw an exception or return a fallback.
    throw Exception("No mapping function found for language codes: $languageCode or $defaultLanguageCode");
  }

  static String getEnglishInitial(String input) {
    if (input.isEmpty) {
      return "#";
    }

    String initialText = input.substring(0, 1).toUpperCase();

    if (RegExp("[A-Z]").hasMatch(initialText)) {
      return initialText;
    } else {
      return "#";
    }
  }

  /// 문자열에 포함된 모든 한글 음절의 초성을 추출하여 반환
  static String getKoreanInitial(String input) {
    if (input.isEmpty) {
      return "#";
    }

    /// 19개 한글 초성 테이블
    const List<String> initials = [
      'ㄱ', // 0
      'ㄲ', // 1
      'ㄴ', // 2
      'ㄷ', // 3
      'ㄸ', // 4
      'ㄹ', // 5
      'ㅁ', // 6
      'ㅂ', // 7
      'ㅃ', // 8
      'ㅅ', // 9
      'ㅆ', // 10
      'ㅇ', // 11
      'ㅈ', // 12
      'ㅉ', // 13
      'ㅊ', // 14
      'ㅋ', // 15
      'ㅌ', // 16
      'ㅍ', // 17
      'ㅎ', // 18
    ];

    /// 겹받침(쌍자음) -> 기본 초성으로 매핑
    const Map<String, String> doubleToSingle = {
      'ㄲ': 'ㄱ',
      'ㄸ': 'ㄷ',
      'ㅃ': 'ㅂ',
      'ㅆ': 'ㅅ',
      'ㅉ': 'ㅈ',
    };
    final buffer = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final codeUnit = char.codeUnitAt(0);

      // 유니코드 한글 범위(가 ~ 힣) 내에 있는지 확인
      if (codeUnit >= 0xAC00 && codeUnit <= 0xD7A3) {
        // '가'(U+AC00)를 0으로 두었을 때의 오프셋
        final base = codeUnit - 0xAC00;
        // 초성 인덱스: 각 초성은 588개 음절 단위로 구분
        final initialIndex = base ~/ 588;

        // 해당 음절의 초성
        String initial = initials[initialIndex];

        // 쌍자음은 기본 자음으로 치환
        if (doubleToSingle.containsKey(initial)) {
          initial = doubleToSingle[initial]!;
        }

        buffer.write(initial);
      } else {
        buffer.write("#");
      }
    }

    return buffer.toString().substring(0, 1);
  }
}
