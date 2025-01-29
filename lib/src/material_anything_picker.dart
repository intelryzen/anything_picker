import 'package:anything_picker/src/anything_picker/const/anything_picker_const.dart';
import 'package:anything_picker/src/anything_picker/model/anything.dart';
import 'package:anything_picker/src/anything_picker/styles/styles.dart';
import 'package:anything_picker/src/anything_picker/util/anything_picker_util.dart';
import 'package:anything_picker/src/azlistview_plus/azlistview_plus.dart';
import 'package:anything_picker/src/bottom_modal_scroll_physics.dart';
import 'package:anything_picker/src/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class MaterialAnythingPicker extends StatefulWidget {
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

  const MaterialAnythingPicker(
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
        itemHeight = itemHeight ?? MaterialStyle.itemHeight;

  @override
  State<MaterialAnythingPicker> createState() => _MaterialAnythingPickerState();
}

class _MaterialAnythingPickerState extends State<MaterialAnythingPicker> {
  List<Anything> originList = [];
  List<Anything> dataList = [];

  final textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late final ItemScrollController itemScrollController =
      ItemScrollController(scrollController: widget.scrollController);
  late List<String> indexBarData = widget.indexBarData;
  bool isScrolled = false;
  bool textFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialPaletteUtil.background(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MaterialPaletteUtil.background(context),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 56,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: textFieldVisible
            ? TextField(
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  suffixIcon: textEditingController.text.isNotEmpty
                      ? InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          child: Icon(
                            Icons.close,
                            color: MaterialPaletteUtil.text(context),
                          ),
                          onTap: () {
                            textEditingController.clear();
                            _search("");
                          },
                        )
                      : null,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: MaterialStyle.textFieldTextSize,
                    color: MaterialPaletteUtil.textFieldIconColor(context),
                  ),
                ),
                onChanged: (value) {
                  _search(value);
                },
                style: TextStyle(
                  color: MaterialPaletteUtil.text(context),
                  fontSize: MaterialStyle.textFieldTextSize,
                ),
              )
            : Text(
                widget.title,
                style: TextStyle(
                  fontSize: 17,
                  color: MaterialPaletteUtil.text(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MaterialPaletteUtil.text(context),
          ),
          onPressed: () {
            if (textFieldVisible) {
              setState(() {
                textFieldVisible = !textFieldVisible;
                textEditingController.clear();
                _search("");
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (!textFieldVisible)
            IconButton(
              onPressed: () {
                setState(() {
                  textFieldVisible = true;
                });
                focusNode.requestFocus();
              },
              color: MaterialPaletteUtil.text(context),
              icon: Icon(Icons.search),
            )
        ],
      ),
      body: AzListView(
        data: dataList,
        itemCount: dataList.length,
        stickyHeader: widget.stickyHeader,
        indexBarData: indexBarData,
        physics: const BottomModalScrollPhysics(),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        itemScrollController: itemScrollController,
        susItemBuilder: (BuildContext context, int index) {
          final model = dataList[index];
          return _getSusItem(context, model.getSuspensionTag());
        },
        susItemHeight: MaterialStyle.susHeight,
        itemHeight: widget.itemHeight,
        indexBarItemHeight: MaterialStyle.indexBarItemHeight,
        indexBarWidth: MaterialStyle.indexBarWidth,
        indexBarOptions: IndexBarOptions(
          hapticFeedback: true,
          needRebuild: true,
          indexHintOffset: Offset(0, 0),
          indexHintTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MaterialPaletteUtil.indexHintText(context),
          ),
          indexHintDecoration: BoxDecoration(
              color: MaterialPaletteUtil.indexHintColor(context),
              borderRadius: BorderRadius.circular(MaterialStyle.radius)),
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        itemBuilder: _itemBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final Anything data = dataList[index];
    final bool isSelected = widget.selectedCode == data.code;

    final firstIndex = dataList.indexWhere((e) => e.tagIndex == data.tagIndex);
    final lastIndex =
        dataList.lastIndexWhere((e) => e.tagIndex == data.tagIndex);
    final bool isFirst = firstIndex == index;
    final bool isLast = lastIndex == index;

    final borderRadius = BorderRadius.only(
      topLeft: isFirst ? Radius.circular(MaterialStyle.radius) : Radius.zero,
      topRight: isFirst ? Radius.circular(MaterialStyle.radius) : Radius.zero,
      bottomLeft: isLast ? Radius.circular(MaterialStyle.radius) : Radius.zero,
      bottomRight: isLast ? Radius.circular(MaterialStyle.radius) : Radius.zero,
    );

    return Container(
      height: widget.itemHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: MaterialStyle.padding),
      child: Material(
        color: MaterialPaletteUtil.itemColor(context),
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
                      horizontal: MaterialStyle.padding),
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
                                      color: MaterialPaletteUtil.text(context),
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
                                            MaterialPaletteUtil.text(context),
                                        height: 1,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
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
                    horizontal: MaterialStyle.padding),
                child: Divider(
                  height: 1,
                  thickness: 0,
                  color: MaterialPalette.dividerColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getSusItem(BuildContext context, String tag,
      {double susHeight = MaterialStyle.susHeight}) {
    if (tag == "☆" && widget.favoriteTitle != null) {
      tag = widget.favoriteTitle!;
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: MaterialStyle.padding * 2, bottom: 6),
      alignment: Alignment.bottomLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
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
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
