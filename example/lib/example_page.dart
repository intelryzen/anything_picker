import 'package:example/anything_const.dart';
import 'package:example/anything_data.dart';
import 'package:example/anything_picker.dart';
import 'package:example/initial_consonant_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_info_plus/language_info_plus.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print("object");
        },
        onVerticalDragStart: (details) {
          print("object");
          // 드래그 시작 지점 기록
        },
        onVerticalDragUpdate: (details) {
          print("object");

          // 드래그 거리 계산
        },
        onVerticalDragEnd: (details) {
          print("object");
        },
        child: Container(
          child: TextButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //         builder: (context) => ModalInsideModal()));
                showAdaptivePicker(context);
              },
              child: Text(InitialConsonantUtil.getKoreanInitial("가x"))),
        ),
      )),
    );
  }
}

Future showAdaptivePicker(BuildContext context) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AnythingPicker(
        ModalScrollController.of(context)!,
        title: "지역 선택",
        hintText: "검색",
        selectedCode: "ko",
        favoriteCodes: ["ko"],
        // tagIndexMapper: InitialConsonantUtil.getKoreanInitial,
        dataList: LanguageInfoPlus.languages
            .map((e) => AnythingData(e.code, e.name, subtext: e.localizedName))
            .toList(),
      ),
    );
  } else {
    // return await showCupertinoModalBottomSheet(
    //   expand: true,
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => AnythingPicker(
    //     ModalScrollController.of(context)!,
    //     dataList: LanguageInfoPlus.languages
    //         .map((e) => AnythingData(e.code, e.name, subtext: e.localizedName))
    //         .toList(),
    //   ),
    // );
  }
}
