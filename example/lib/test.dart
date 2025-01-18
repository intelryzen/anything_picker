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
  final bool reverse;

  ModalInsideModal({super.key, this.reverse = false});

  @override
  State<ModalInsideModal> createState() => _ModalInsideModalState();
}

class _ModalInsideModalState extends State<ModalInsideModal> {
  // Scroll offset listener
  final ScrollController _azScrollController = ScrollController();

  List<Language> originList = [];
  List<Language> dataList = [];

  final ScrollController _scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();

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
    // _scrollController.addListener(() {
    //   if (_scrollController.position.extentAfter == 0 &&
    //       _scrollController.position.pixels >
    //           _scrollController.position.maxScrollExtent) {
    //     // 현재 스크롤이 overflow 되었음을 감지
    //     setState(() {
    //       _isOverflow = true;
    //     });
    //   } else {
    //     // 정상 범위 내로 돌아왔을 때
    //     setState(() {
    //       _isOverflow = false;
    //     });
    //   }
    // });
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

  @override
  Widget build(BuildContext context) {
    final con = ModalScrollController.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.white,
        surfaceTintColor: CupertinoColors.systemGrey,
        toolbarHeight: 60,
        title: Text(
          "지역 선택",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: SizedBox(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: 56,
              child: Align(
                alignment: Alignment.topCenter,
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      fillColor: Palette.textFieldBackground,
                      filled: true,
                      isDense: true,
                      prefixIconConstraints: BoxConstraints(minWidth: 38),
                      prefixIcon: Icon(CupertinoIcons.search, size: 24),
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
                          fontSize: 18, color: CupertinoColors.secondaryLabel)),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () {},
                highlightColor: Colors.transparent,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    CupertinoColors.systemGrey5,
                  ),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                color: CupertinoColors.secondaryLabel,
                iconSize: 22,
                icon: Icon(
                  Icons.clear,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Palette.background,
      body: AzListView(
          data: dataList,
          itemCount: dataList.length,
          physics: ClampingScrollPhysics(),
          itemScrollController: ItemScrollController(
              scrollController: ModalScrollController.of(context)),
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
          indexBarOptions: IndexBarOptions(
            hapticFeedback: true,
            textStyle: TextStyle(
              color: CupertinoColors.systemBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 50,
              child: ListTile(
                title: Text(dataList[index].text),
              ),
            );
          }),
    );
  }

  Widget getSusItem(BuildContext context, String tag,
      {double susHeight = Style.susHeight}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 18.0),
      color: Palette.susItemColor,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(fontSize: 14.0, color: Palette.susTextColor),
      ),
    );
  }
}
