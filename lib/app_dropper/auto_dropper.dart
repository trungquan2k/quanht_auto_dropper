import 'package:flutter/material.dart';
import 'package:quanht_auto_dropper/config/config.index.dart';
import 'package:quanht_auto_dropper/models/drop_item.dart';
import 'package:quanht_auto_dropper/styles/auto_drop.style.dart';
import 'package:quanht_auto_dropper/styles/text_drop.style.dart';
import 'package:quanht_auto_dropper/widgets/assets_prefix_drop.dart';
import 'package:quanht_auto_dropper/widgets/hintext_drop.dart';

import 'auto_drop_overlay.dart';

class AppAutoDropdown extends StatefulWidget {
  final ScrollController? parentScrollController;
// Controls the scrolling behavior of the parent widget.

  /// Called when the selected dropdown option changes.
  /// Passes the selected `DropItem` and its index.
  final void Function(DropItem) onSelected;

  /// The list of items to display in the dropdown menu.
  final List<DropItem> items;

  /// Styles for the dropdown button, passed to `OutlineButton.styleFrom()`.
  final AutoDropButtonStyle dropdownButtonStyle;

  /// Styles for the dropdown menu.
  final AutoDropStyle dropdownStyle;

  /// Icon to display on the dropdown button; defaults to a caret icon if not provided.
  final Widget? icon;

  /// If true, the dropdown button icon is hidden.
  final bool hideIcon;

  /// The color of the dropdown items.
  final Color? colorItem;

  /// The background color of the dropdown menu.
  final Color? bgColorDropDown;

  /// If true, highlights the selected dropdown item with a specific color.
  final bool isHighLightColor;

  /// Styles for the dropdown items' text.
  final TextDropStyle itemStyle;

  /// The hint text displayed when no item is selected.
  final String hintText;

  /// Styles for the hint text in the dropdown.
  final TextDropStyle hintTextDropStyle;

  /// Styles for the dropdown label text.
  final TextDropStyle labelDropStyle;

  /// The label text displayed for the dropdown.
  final String label;

  /// Determines if the dropdown is enabled for user interaction.
  final bool enabled;

  /// If true, displays a prefix widget alongside the dropdown button.
  final bool visiblePrefix;

  /// The file path to an asset used in the dropdown.
  final String assetFile;

  /// A custom widget for the dropdown button, typically used in place of the default icon.
  final Widget assetWidget;

  /// The initial value selected in the dropdown, if any.
  final String? initialValue;

  /// Styles for the main text displayed in the dropdown.
  final TextDropStyle textDropStyle;

  /// If true, displays a background for each dropdown item.
  final bool isShowBgItem;

  /// The background color of individual dropdown items.
  final Color? bgColorItem;

  const AppAutoDropdown({
    super.key,
    this.parentScrollController,
    required this.onSelected,
    required this.items,
    this.dropdownStyle = const AutoDropStyle(),
    this.dropdownButtonStyle = const AutoDropButtonStyle(),
    this.icon,
    this.hideIcon = false,
    this.enabled = true,
    required this.hintText,
    this.isHighLightColor = true,
    this.bgColorDropDown,
    this.visiblePrefix = false,
    this.isShowBgItem = false,
    this.assetFile = '',
    this.assetWidget = const Offstage(),
    this.colorItem,
    this.initialValue,
    this.label = '',
    this.labelDropStyle = const TextDropStyle(),
    this.textDropStyle = const TextDropStyle(),
    this.hintTextDropStyle = const TextDropStyle(),
    this.itemStyle = const TextDropStyle(),
    this.bgColorItem,
  });

  @override
  State<AppAutoDropdown> createState() => _AppAutoDropdownState();
}

class _AppAutoDropdownState extends State<AppAutoDropdown> {
  Color get colorIcon => widget.enabled
      ? (_valueEmpty)
          ? Colors.black
          : Colors.black
      : Colors.black.toOpacity(.9);

  bool get _valueEmpty => _selectedValue.name.isEmpty;
  DropItem _selectedValue = DropItem(name: '', id: -1);

  _onSelected(DropItem output) {
    widget.onSelected(output);
    _selectedValue = output;
    setState(() {});
  }

  int? get initValue =>
      (parseToNull(widget.initialValue) == null && widget.items.isNotEmpty)
          ? null
          : int.parse(widget.initialValue ?? '0');

  @override
  void initState() {
    _sync();
    super.initState();
  }

  _sync() {
    if (parseToNull(widget.initialValue) != null && widget.items.isNotEmpty) {
      _selectedValue = widget.items.elementAt(initValue ?? 0);
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant AppAutoDropdown oldWidget) {
    _sync();
    super.didUpdateWidget(oldWidget);
  }

  _visibleBgColorItem(int key) =>
      widget.isShowBgItem && widget.items.length > 3 && (key + 1) % 2 != 0;

  @override
  Widget build(BuildContext context) {
    Color titleColor = widget.enabled
        ? (_selectedValue.name.isEmpty
            ? Colors.black.toOpacity(0.6)
            : Colors.black)
        : Colors.black.toOpacity(.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isEmpty) ...[
          Text(
            widget.label,
            maxLines: widget.labelDropStyle.maxLines ?? 1,
            overflow: widget.labelDropStyle.overflow,
            style: TextStyle(
              fontSize: widget.labelDropStyle.fontSize,
              fontWeight: widget.labelDropStyle.fontWeight,
              color: widget.labelDropStyle.textColor ?? titleColor,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        AutoDropOverLay<DropItem>(
          parentScrollController: widget.parentScrollController,
          onSelected: _onSelected,
          enabled: widget.enabled,
          dropButtonStyle: widget.dropdownButtonStyle,
          dropStyle: widget.dropdownStyle,
          items: widget.items.asMap().entries.map(
            (item) {
              return DropListWidget<DropItem>(
                value: item.value,
                child: _buildItemList(item),
              );
            },
          ).toList(),
          child: Expanded(
            child: _valueEmpty ? _buildHintText() : _hasValueSelected(),
          ),
        ),
      ],
    );
  }

  Widget _buildItemList(MapEntry<int, DropItem<dynamic>> item) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _visibleBgColorItem(item.key)
          ? BoxDecoration(
              color: (widget.bgColorItem ?? Colors.grey).toOpacity(0.3),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.value.name,
              overflow: widget.itemStyle.overflow,
              maxLines: widget.itemStyle.maxLines ?? 4,
              style: TextStyle(
                fontSize: widget.itemStyle.fontSize,
                color:
                    widget.itemStyle.textColor ?? Colors.black.toOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 2.0),
          if (_selectedValue.id == item.value.id)
            Icon(Icons.check, weight: 16.0),
        ],
      ),
    );
  }

  Widget _hasValueSelected() {
    return Row(
      children: [
        AssetsPrefixDrop(
          isHiden: widget.visiblePrefix,
          path: widget.assetFile,
          assetWidget: widget.assetWidget,
        ),
        Expanded(
          child: Text(
            _selectedValue.name,
            overflow: widget.textDropStyle.overflow,
            maxLines: widget.textDropStyle.maxLines ?? 1,
            style: TextStyle(
                fontWeight: widget.textDropStyle.fontWeight,
                fontSize: widget.textDropStyle.fontSize,
                color: (widget.textDropStyle.textColor ?? Colors.black)
                    .toOpacity(widget.enabled ? 1 : 0.6)),
          ),
        ),
      ],
    );
  }

  Widget _buildHintText() {
    return Row(
      children: [
        AssetsPrefixDrop(
          isHiden: widget.visiblePrefix,
          path: widget.assetFile,
          assetWidget: widget.assetWidget,
        ),
        HintextDrop(
          hintText: widget.hintText,
          hintTextStyle: widget.hintTextDropStyle,
        ),
      ],
    );
  }
}
