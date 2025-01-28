import 'package:anything_picker/anything_picker.dart';

/// ISuspension Bean.
abstract class ISuspensionBean {
  bool isShowSuspension = false;

  String getSuspensionTag(); //Suspension Tag
}

/// Suspension Util.
class SuspensionUtil {
  /// sort list by suspension tag.
  /// 根据[A-Z]排序。
  static void sortListBySuspensionTag(List<ISuspensionBean>? list) {
    if (list == null || list.isEmpty) return;

    // 원래 인덱스를 저장
    final originalIndexMap = {
      for (int i = 0; i < list.length; i++) list[i]: i
    };

    list.sort((a, b) {
      if (a.getSuspensionTag() == "☆" && b.getSuspensionTag() == "☆") {
        // `☆`를 가진 요소끼리는 기존 순서를 유지
        return originalIndexMap[a]!.compareTo(originalIndexMap[b]!);
      } else if (a.getSuspensionTag() == b.getSuspensionTag()) {
        // `getSuspensionTag` 같으면 sortingKey로 오름차순 정렬

        // typecasting
        final anythingA = (a as Anything);
        final anythingB = (b as Anything);

        return (anythingA.sortingKey ?? anythingA.text).compareTo(
            (anythingB.sortingKey ?? anythingB.text));
      } else if (a.getSuspensionTag() == "☆") {
        return -1; // `a`가 `☆`이면 항상 앞쪽
      } else if (b.getSuspensionTag() == "☆") {
        return 1; // `b`가 `☆`이면 항상 뒤쪽
      } else if (a.getSuspensionTag() == "@" || b.getSuspensionTag() == "#") {
        return -1;
      } else if (a.getSuspensionTag() == "#" || b.getSuspensionTag() == "@") {
        return 1;
      } else {
        return a.getSuspensionTag().compareTo(b.getSuspensionTag());
      }
    });
  }

  /// get index data list by suspension tag.
  /// 获取索引列表。
  static List<String> getTagIndexList(List<ISuspensionBean>? list) {
    List<String> indexData = [];
    if (list != null && list.isNotEmpty) {
      String? tempTag;
      for (int i = 0, length = list.length; i < length; i++) {
        String tag = list[i].getSuspensionTag();
        if (tempTag != tag) {
          indexData.add(tag);
          tempTag = tag;
        }
      }
    }
    return indexData;
  }

  /// set show suspension status.
  /// 设置显示悬停Header状态。
  static void setShowSuspensionStatus(List<ISuspensionBean>? list) {
    if (list == null || list.isEmpty) return;
    String? tempTag;
    for (int i = 0, length = list.length; i < length; i++) {
      String tag = list[i].getSuspensionTag();
      if (tempTag != tag) {
        tempTag = tag;
        list[i].isShowSuspension = true;
      } else {
        list[i].isShowSuspension = false;
      }
    }
  }
}