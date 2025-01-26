import 'package:anything_picker/src/anything_picker.dart';
import 'package:anything_picker/src/anything_picker/model/anything.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future showAnythingPicker(
  BuildContext context, {
  required String title,
  required String hintText,
  required List<Anything> dataList,
  List<String>? favoriteCodes,
  List<String>? indexBarData,
  String? selectedCode,
  bool? isSortBySubtext,
  String Function(String)? tagIndexMapper,
  Widget Function(BuildContext context, Anything data, bool isSelected)?
      customItemBuilder,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return await CupertinoScaffold.showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AnythingPicker(
        ModalScrollController.of(context)!,
        title: title,
        hintText: hintText,
        dataList: dataList, 
        indexBarData: indexBarData,
        selectedCode: selectedCode,
        favoriteCodes: favoriteCodes,
        tagIndexMapper: tagIndexMapper,
        isSortBySubtext: isSortBySubtext,
        customItemBuilder: customItemBuilder,
      ),
    );
  } else {
    // return await showCupertinoModalBottomSheet(
    //   expand: true,
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => AnythingPicker(
    //     ModalScrollController.of(context)!,
    //     title: "지역 선택",
    //     hintText: "검색",
    //     selectedCode: "ko",
    //     favoriteCodes: ["ko"],
    //     // tagIndexMapper: AnythingPickerUtil.getKoreanInitial,
    //     dataList: LanguageInfoPlus.languages
    //         .map((e) => Anything(e.code, e.name, subtext: e.name))
    //         .toList(),
    //   ),
    // );
  }
}
