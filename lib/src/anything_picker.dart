import 'package:anything_picker/src/anything_picker/const/anything_picker_const.dart';
import 'package:anything_picker/src/anything_picker/model/anything.dart';
import 'package:anything_picker/src/anything_picker/styles/styles.dart';
import 'package:anything_picker/src/anything_picker/util/anything_picker_util.dart';
import 'package:anything_picker/src/azlistview_plus/azlistview_plus.dart';
import 'package:anything_picker/src/bottom_modal_scroll_physics.dart';
import 'package:anything_picker/src/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnythingPicker extends StatefulWidget {
  final List<Anything> dataList;
  final bool stickyHeader;
  final ScrollController scrollController;
  final String title;
  final String hintText;
  final String? favoriteTitle;
  final List<String> indexBarData;
  final List<String> favoriteCodes;
  final String Function(String) tagIndexMapper;
  final Widget Function(BuildContext context, Anything data, bool isSelected)?
      customItemBuilder;
  final String? selectedCode;
  final double itemHeight;

  const AnythingPicker(
    this.scrollController, {
    required this.dataList,
    required this.title,
    required this.hintText,
    this.stickyHeader = false,
    this.selectedCode,
    this.favoriteTitle,
    this.customItemBuilder,
    double? itemHeight,
    List<String>? favoriteCodes,
    List<String>? indexBarData,
    String Function(String)? tagIndexMapper,
    super.key,
  })  : tagIndexMapper = tagIndexMapper ?? AnythingPickerUtil.getEnglishInitial,
        favoriteCodes = favoriteCodes ?? const [],
        indexBarData = indexBarData ?? indexBarEnglishData,
        itemHeight = itemHeight ?? CupertinoStyle.itemHeight;

  @override
  State<AnythingPicker> createState() => _AnythingPickerState();
}

class _AnythingPickerState extends State<AnythingPicker> {
  List<Anything> originList = [];
  List<Anything> dataList = [];

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
            color: CupertinoPaletteUtil.text(context),
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
              left: CupertinoStyle.padding,
              right: CupertinoStyle.padding,
              bottom: 15,
            ),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                fillColor: CupertinoPaletteUtil.textFieldBackground(context),
                filled: true,
                isDense: true,
                prefixIconConstraints: BoxConstraints(
                    minWidth: 34, maxHeight: CupertinoStyle.textFieldIconSize),
                prefixIcon: Icon(CupertinoIcons.search,
                    size: CupertinoStyle.textFieldIconSize),
                prefixIconColor:
                    CupertinoPaletteUtil.textFieldIconColor(context),
                suffixIconConstraints: BoxConstraints(
                    maxWidth: 34, maxHeight: CupertinoStyle.textFieldIconSize),
                suffixIcon: textEditingController.text.isNotEmpty
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: CupertinoStyle.textFieldIconSize,
                          color:
                              CupertinoPaletteUtil.textFieldIconColor(context),
                        ),
                        onPressed: () {
                          textEditingController.clear();
                          _search("");
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(CupertinoStyle.radius),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(CupertinoStyle.radius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(CupertinoStyle.radius),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: CupertinoStyle.textFieldTextSize,
                  color: CupertinoPaletteUtil.textFieldIconColor(context),
                ),
              ),
              onChanged: (value) {
                _search(value);
              },
              style: TextStyle(
                color: CupertinoPaletteUtil.text(context),
                fontSize: CupertinoStyle.textFieldTextSize,
              ),
              cursorHeight: 22,
            ),
          ),
          if (isScrolled)
            Divider(
              height: 0,
              thickness: 0,
              color: CupertinoPaletteUtil.appBarDivider(context),
            ),
          Expanded(
            child: AzListView(
              data: dataList,
              itemCount: dataList.length,
              stickyHeader: widget.stickyHeader,
              indexBarData: indexBarData,
              physics: const BottomModalScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              itemScrollController: itemScrollController,
              susItemBuilder: (BuildContext context, int index) {
                final model = dataList[index];
                return _getSusItem(context, model.getSuspensionTag());
              },
              susItemHeight: CupertinoStyle.susHeight,
              itemHeight: widget.itemHeight,
              indexBarItemHeight: CupertinoStyle.indexBarItemHeight,
              indexBarWidth: CupertinoStyle.indexBarWidth,
              indexBarOptions: IndexBarOptions(
                hapticFeedback: true,
                needRebuild: true,
                indexHintOffset: Offset(0, 0),
                indexHintTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoPaletteUtil.indexHintText(context),
                ),
                indexHintDecoration: BoxDecoration(
                    color: CupertinoPaletteUtil.indexHintColor(context),
                    borderRadius: BorderRadius.circular(CupertinoStyle.radius)),
                textStyle: TextStyle(
                  color: CupertinoPaletteUtil.primary(context),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              itemBuilder: _itemBuilder,
            ),
          ),
        ],
      ),
      backgroundColor: CupertinoPaletteUtil.background(context),
      resizeToAvoidBottomInset: false,
    );
  }

  Color get appBarBackground => isScrolled
      ? CupertinoPaletteUtil.scrolledAppBarColor(context)
      : CupertinoPaletteUtil.background(context);

  Widget _itemBuilder(BuildContext context, int index) {
    final Anything data = dataList[index];
    final bool isSelected = widget.selectedCode == data.code;

    final firstIndex = dataList.indexWhere((e) => e.tagIndex == data.tagIndex);
    final lastIndex =
        dataList.lastIndexWhere((e) => e.tagIndex == data.tagIndex);
    final bool isFirst = firstIndex == index;
    final bool isLast = lastIndex == index;

    final borderRadius = BorderRadius.only(
      topLeft: isFirst ? Radius.circular(CupertinoStyle.radius) : Radius.zero,
      topRight: isFirst ? Radius.circular(CupertinoStyle.radius) : Radius.zero,
      bottomLeft: isLast ? Radius.circular(CupertinoStyle.radius) : Radius.zero,
      bottomRight:
          isLast ? Radius.circular(CupertinoStyle.radius) : Radius.zero,
    );

    return Container(
      height: widget.itemHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: CupertinoStyle.padding),
      child: Material(
        color: CupertinoPaletteUtil.itemColor(context),
        borderRadius: borderRadius,
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, data.code);
                },
                borderRadius: borderRadius,
                splashColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CupertinoStyle.padding),
                  child: widget.customItemBuilder != null
                      ? widget.customItemBuilder!(context, data, isSelected)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 4,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 3,
                                children: [
                                  Text(
                                    data.text,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoPaletteUtil.text(context),
                                      height: 1,
                                    ),
                                  ),
                                  if (data.subtext != null)
                                    Text(
                                      data.subtext!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            CupertinoPaletteUtil.text(context),
                                        height: 1,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.check_mark,
                                color: CupertinoPaletteUtil.primary(context),
                              )
                          ],
                        ),
                ),
              ),
            ),
            if (index != dataList.length - 1 &&
                data.getSuspensionTag() ==
                    dataList[index + 1].getSuspensionTag())
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CupertinoStyle.padding),
                child: Divider(
                  height: 1,
                  thickness: 0,
                  color: CupertinoPalette.dividerColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getSusItem(BuildContext context, String tag,
      {double susHeight = CupertinoStyle.susHeight}) {
    if (tag == "☆" && widget.favoriteTitle != null) {
      tag = widget.favoriteTitle!;
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: CupertinoStyle.padding * 2, bottom: 6),
      alignment: Alignment.bottomLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: CupertinoPalette.susTextColor,
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

  void _handleList(List<Anything> list) {
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
      value.tagIndex = widget.tagIndexMapper(value.sortingKey ?? value.text);
      if (value.tagIndex == "#") {
        existsUnsupportedChar = true;
      }
      return value;
    }).toList();

    for (String code in widget.favoriteCodes.reversed) {
      try {
        final data = originList
            .firstWhere((e) => e.code == code)
            .copyWith(tagIndex: "☆");
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
//     padding: const EdgeInsets.only(right: CupertinoStyle.padding),
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
