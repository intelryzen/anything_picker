import 'package:example/azlistview_plus/azlistview_plus.dart';
import 'package:example/palette.dart';
import 'package:example/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:example/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:world_info_plus/world_info_plus.dart';
import 'package:example/language.dart';

class ModalInsideModal extends StatefulWidget {
  final ScrollController scrollController;

  const ModalInsideModal(
    this.scrollController, {
    super.key,
  });

  @override
  State<ModalInsideModal> createState() => _ModalInsideModalState();
}

class _ModalInsideModalState extends State<ModalInsideModal> {
  List<Language> originList = [];
  List<Language> dataList = [];
  bool isScrolled = false; // 스크롤 상태를 저장하는 변수

  late final ItemScrollController itemScrollController =
      ItemScrollController(scrollController: widget.scrollController);

  @override
  void initState() {
    super.initState();
    originList = WorldInfoPlus.countries.map((v) {
      Language model = Language(v.shortName);
      String tag = model.text.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        model.tagIndex = tag;
      } else {
        model.tagIndex = "#";
      }
      return model;
    }).toList();
    _handleList(originList);

    // ScrollController의 listener 추가
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 0 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (widget.scrollController.offset <= 0 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });
  }

  void _handleList(List<Language> list) {
    dataList.clear();
    if (isEmpty(list)) {
      setState(() {});
      return;
    }
    dataList.addAll(list);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(dataList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(dataList);

    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }

  static bool isEmpty(Object? object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is Iterable && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  Color get backgroundColor =>
      isScrolled ? Palette.scrolledAppBarColor : CupertinoColors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 56,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "지역 선택",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const SizedBox(),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: Style.padding),
        //     child: SizedBox(
        //       height: 30,
        //       width: 30,
        //       child: CupertinoButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         padding: EdgeInsets.zero,
        //         color: CupertinoColors.systemGrey5,
        //         borderRadius: BorderRadius.circular(360),
        //         child: Icon(
        //           color: CupertinoColors.secondaryLabel,
        //           Icons.clear,
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),
      backgroundColor: Palette.background,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.only(
              left: Style.padding,
              right: Style.padding,
              bottom: 15,
            ),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                fillColor: Palette.textFieldBackground,
                filled: true,
                isDense: true,
                prefixIconConstraints: BoxConstraints(minWidth: 34),
                prefixIcon: Icon(CupertinoIcons.search, size: 21),
                prefixIconColor: CupertinoColors.systemGrey,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "검색",
                hintStyle: TextStyle(
                    fontSize: 18, color: CupertinoColors.secondaryLabel),
              ),
              style: TextStyle(fontSize: 18),
              cursorHeight: 22,
            ),
          ),
          if (isScrolled)
            Divider(
              height: 0,
              thickness: 0,
              color: CupertinoColors.systemGrey,
            ),
          Expanded(
            child: AzListView(
                data: dataList,
                itemCount: dataList.length,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                itemScrollController: itemScrollController,
                // susItemBuilder: (BuildContext context, int index) {
                //   Language model = list[index];
                //   String tag = model.getSuspensionTag();
                //   if (imgFavorite == tag) {
                //     return Container();
                //   }
                //   return Utils.getSusItem(context, tag, susHeight: susItemHeight);
                // },
                susItemBuilder: (BuildContext context, int index) {
                  Language model = dataList[index];
                  return getSusItem(context, model.getSuspensionTag());
                },
                susItemHeight: Style.susHeight,
                indexBarItemHeight: Style.indexBarItemHeight,
                indexBarWidth: Style.indexBarWidth,
                indexBarOptions: IndexBarOptions(
                  hapticFeedback: true,
                  needRebuild: true,
                  indexHintOffset: Offset(0, 0),
                  textStyle: TextStyle(
                      color: CupertinoColors.systemBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        height: Style.itemHeight,
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: Style.padding),
                        child: Text(
                          dataList[index].text,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (index != dataList.length - 1 &&
                          dataList[index].getSuspensionTag() ==
                              dataList[index + 1].getSuspensionTag())
                        Divider(
                          height: 0,
                          thickness: 0,
                          color: Palette.separatedColor,
                        )
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget getSusItem(BuildContext context, String tag,
      {double susHeight = Style.susHeight}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 18.0),
      color: isScrolled
          ? Palette.scrolledAppBarColor // 스크롤 시 색상
          : Palette.susItemColor,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Palette.susTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
