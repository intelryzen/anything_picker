import 'package:anything_picker/src/cupertino_anything_picker.dart';
import 'package:anything_picker/src/anything_picker/model/anything.dart';
import 'package:anything_picker/src/material_anything_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future showAnythingPicker(
  BuildContext context, {
  required String title,
  required String hintText,
  required List<Anything> dataList,
  List<String>? favoriteCodes,
  List<String>? indexBarData,
  String? selectedCode,
  String? favoriteTitle,
  double? itemHeight,
  String Function(String)? tagIndexMapper,
  Widget Function(BuildContext context, Anything data, bool isSelected)?
      customItemBuilder,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return await CupertinoScaffold.showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CupertinoAnythingPicker(
        ModalScrollController.of(context)!,
        title: title,
        hintText: hintText,
        dataList: dataList,
        itemHeight: itemHeight,
        indexBarData: indexBarData,
        selectedCode: selectedCode,
        favoriteCodes: favoriteCodes,
        tagIndexMapper: tagIndexMapper,
        favoriteTitle: favoriteTitle,
        customItemBuilder: customItemBuilder,
      ),
    );
  } else {
    return await showMaterialModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => MaterialAnythingPicker(
        ModalScrollController.of(context)!,
        title: title,
        hintText: hintText,
        dataList: dataList,
        itemHeight: itemHeight,
        indexBarData: indexBarData,
        selectedCode: selectedCode,
        favoriteCodes: favoriteCodes,
        favoriteTitle: favoriteTitle,
        tagIndexMapper: tagIndexMapper,
        customItemBuilder: customItemBuilder,
      ),
    );
  }
}
