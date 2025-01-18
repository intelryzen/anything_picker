import 'package:example/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ModalInsideModal(),
                );
              },
              child: Text("이동")),
        ),
      )),
    );
  }
}
