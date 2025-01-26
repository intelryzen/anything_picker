import 'package:common_utils/common_utils.dart';
import 'package:example/anything_const.dart';
import 'package:example/azlistview_plus/azlistview_plus.dart';
import 'package:example/initial_consonant_util.dart';
import 'package:example/palette.dart';
import 'package:example/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:example/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/anything_data.dart';

class AnythingPicker extends StatefulWidget {
  final List<AnythingData> dataList;
  final bool stickyHeader;
  final ScrollController scrollController;
  final String title;
  final String hintText;
  final List<String> indexBarData;
  final List<String> favoriteCodes;
  final String Function(String) tagIndexMapper;
  final Widget Function(
          BuildContext context, AnythingData data, bool isSelected)?
      customItemBuilder;
  final String? selectedCode;
  final double itemHeight;
  final bool isSortBySubtext;

  const AnythingPicker(
    this.scrollController, {
    required this.dataList,
    required this.title,
    required this.hintText,
    this.stickyHeader = false,
    this.tagIndexMapper = InitialConsonantUtil.getEnglishInitial,
    this.indexBarData = indexBarEnglishData,
    this.favoriteCodes = const [],
    this.selectedCode,
    this.customItemBuilder,
    this.itemHeight = Style.itemHeight,
    this.isSortBySubtext = false,
    super.key,
  });

  @override
  State<AnythingPicker> createState() => _AnythingPickerState();
}

class _AnythingPickerState extends State<AnythingPicker> {
  List<AnythingData> originList = [];
  List<AnythingData> dataList = [];

  final textEditingController = TextEditingController();
  late final ItemScrollController itemScrollController =
      ItemScrollController(scrollController: widget.scrollController);
  late List<String> indexBarData = widget.indexBarData;

  bool isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackground,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 56,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const SizedBox(),
      ),
      body: Column(
        children: [
          Container(
            color: appBarBackground,
            padding: const EdgeInsets.only(
              left: Style.padding,
              right: Style.padding,
              bottom: 15,
            ),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                fillColor: Palette.textFieldBackground,
                filled: true,
                isDense: true,
                prefixIconConstraints: BoxConstraints(
                    minWidth: 34, maxHeight: Style.textFieldIconSize),
                prefixIcon:
                    Icon(CupertinoIcons.search, size: Style.textFieldIconSize),
                prefixIconColor: Palette.textFieldIconColor,
                suffixIconConstraints: BoxConstraints(
                    maxWidth: 34, maxHeight: Style.textFieldIconSize),
                suffixIcon: textEditingController.text.isNotEmpty
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.clear,
                          size: Style.textFieldIconSize,
                          color: Palette.textFieldIconColor,
                        ),
                        onPressed: () {
                          textEditingController.clear();
                          _search("");
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Style.radius),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Style.radius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Style.radius),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: Style.textFieldTextSize,
                    color: Palette.textFieldIconColor),
              ),
              onChanged: (value) {
                _search(value);
              },
              style: TextStyle(fontSize: Style.textFieldTextSize),
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
              stickyHeader: widget.stickyHeader,
              indexBarData: indexBarData,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              itemScrollController: itemScrollController,
              susItemBuilder: (BuildContext context, int index) {
                final model = dataList[index];
                return getSusItem(context, model.getSuspensionTag());
              },
              susItemHeight: Style.susHeight,
              itemHeight: widget.itemHeight,
              indexBarItemHeight: Style.indexBarItemHeight,
              indexBarWidth: Style.indexBarWidth,
              indexBarOptions: IndexBarOptions(
                hapticFeedback: true,
                needRebuild: true,
                indexHintOffset: Offset(0, 0),
                indexHintDecoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(Style.radius)),
                textStyle: TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
      backgroundColor: Palette.background,
      resizeToAvoidBottomInset: false,
    );
  }

  Color get appBarBackground =>
      isScrolled ? Palette.scrolledAppBarColor : Palette.background;

  Widget itemBuilder(BuildContext context, int index) {
    final AnythingData data = dataList[index];
    final bool isSelected = widget.selectedCode == data.code;

    final firstIndex = dataList.indexWhere((e) => e.tagIndex == data.tagIndex);
    final lastIndex =
        dataList.lastIndexWhere((e) => e.tagIndex == data.tagIndex);
    final bool isFirst = firstIndex == index;
    final bool isLast = lastIndex == index;

    final borderRadius = BorderRadius.only(
      topLeft: isFirst ? Radius.circular(Style.radius) : Radius.zero,
      topRight: isFirst ? Radius.circular(Style.radius) : Radius.zero,
      bottomLeft: isLast ? Radius.circular(Style.radius) : Radius.zero,
      bottomRight: isLast ? Radius.circular(Style.radius) : Radius.zero,
    );

    return Container(
      height: widget.itemHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Style.padding),
      child: Material(
        color: Palette.white,
        borderRadius: borderRadius,
        child: Column(
          children: [
            Expanded(
              child: widget.customItemBuilder != null
                  ? widget.customItemBuilder!(context, data, isSelected)
                  : InkWell(
                      onTap: () {
                        Navigator.pop(context, data.code);
                      },
                      borderRadius: borderRadius,
                      splashColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Style.padding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 3,
                              children: [
                                Text(
                                  data.text,
                                  style: TextStyle(fontSize: 16, height: 1),
                                ),
                                if (data.subtext != null)
                                  Text(
                                    data.text,
                                    style: TextStyle(fontSize: 12, height: 1),
                                  ),
                              ],
                            ),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.check_mark,
                                color: CupertinoColors.systemBlue,
                              )
                          ],
                        ),
                      ),
                    ),
            ),
            if (index != dataList.length - 1 &&
                data.getSuspensionTag() ==
                    dataList[index + 1].getSuspensionTag())
              Divider(
                height: 1,
                thickness: 0,
                color: Palette.dividerColor,
              )
          ],
        ),
      ),
    );
  }

  Widget getSusItem(BuildContext context, String tag,
      {double susHeight = Style.susHeight}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: Style.padding * 2, bottom: 6),
      alignment: Alignment.bottomLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Palette.susTextColor,
        ),
      ),
    );
  }

  void _search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      _handleList(originList);
    } else {
      final list = originList.where((v) {
        return v.text.toLowerCase().contains(text.toLowerCase()) ||
            (v.subtext ?? "").toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  void _handleList(List<AnythingData> list) {
    dataList.clear();

    if (ObjectUtil.isEmpty(list)) {
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

  @override
  void initState() {
    super.initState();

    bool existsFavorites = false;
    bool existsUnsupportedChar = false;

    originList = widget.dataList.map((value) {
      if (widget.isSortBySubtext) {
        value.tagIndex = widget.tagIndexMapper(value.subtext ?? "");
      } else {
        value.tagIndex = widget.tagIndexMapper(value.text);
      }

      if (value.tagIndex == "#") {
        existsUnsupportedChar = true;
      }
      return value;
    }).toList();

    for (String code in widget.favoriteCodes.reversed) {
      try {
        final data = originList.firstWhere((e) => e.code == code).copyWith();
        data.tagIndex = "☆";
        originList.insert(0, data);
        existsFavorites = true;
      } catch (_) {}
    }

    if (existsFavorites) {
      indexBarData = List.from(indexBarData)..insert(0, "☆");
    }
    if (existsUnsupportedChar) {
      indexBarData = List.from(indexBarData)..add("#");
    }

    _handleList(originList);

    widget.scrollController.addListener(() {
      double currentOffset = widget.scrollController.offset;

      if (currentOffset > 0 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (currentOffset <= 0 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }

      // 스크롤시 키보드 초점 해제
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

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
