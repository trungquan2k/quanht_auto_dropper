library quanht_auto_dropper;

import 'package:flutter/material.dart';
import 'package:quanht_auto_dropper/config/config.index.dart';

import 'app_auto_dropdown/auto_drop_overlay.dart';
import 'models/drop_item.dart';
import 'styles/auto_drop_style.dart';

class AppAutoDropdown extends StatefulWidget {
  final ScrollController parentScrollController;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(DropItem) onSelected;

  /// list of DropdownItems
  final List<DropItem> items;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final AutoDropButtonStyle dropdownButtonStyle;

  final AutoDropStyle dropdownStyle;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool hideIcon;

  final Color? colorItem;
  final Color? colorLabel;

  final Color? bgColorDropDown;

  // highligh color item
  final bool isHighLightColor;

  // value display
  final Color? colorActiveItem;

  final TextStyle? itemStyle;

  // hint text
  final String hintText;

  final TextStyle? hintTextStyle;

  final String? label;

  final TextStyle? labelStyle;

  // enable select
  final bool enabled;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  final bool isShowAssetPrefix;

  final String assetFile;

  final Widget assetWidget;

  final String? initialValue;

  const AppAutoDropdown({
    super.key,
    required this.parentScrollController,
    required this.onSelected,
    required this.items,
    this.dropdownStyle = const AutoDropStyle(),
    this.dropdownButtonStyle = const AutoDropButtonStyle(),
    this.icon,
    this.hideIcon = false,
    this.enabled = true,
    required this.hintText,
    this.isHighLightColor = true,
    this.itemStyle,
    this.hintTextStyle,
    this.bgColorDropDown,
    this.leadingIcon = false,
    this.isShowAssetPrefix = false,
    this.assetFile = '',
    this.assetWidget = const Offstage(),
    this.colorItem,
    this.colorActiveItem,
    this.initialValue,
    this.label,
    this.labelStyle,
    this.colorLabel,
  });

  @override
  State<AppAutoDropdown> createState() => _AppAutoDropdownState();
}

class _AppAutoDropdownState extends State<AppAutoDropdown> {
  Color get colorIcon => widget.enabled
      ? (_valueSelectEmpty)
          ? Colors.black
          : Colors.black
      : Colors.black.toOpacity(.9);

  bool get _valueSelectEmpty => _selectedValue.name.isEmpty;
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
        if (widget.label != null)
          Text(
            widget.label ?? '',
            style: widget.labelStyle ??
                TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.colorLabel ?? titleColor,
                ),
          ),
        const SizedBox(height: 8.0),
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
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: widget.items.length > 3 && (item.key + 1) % 2 != 0
                          ? Colors.grey.toOpacity(0.3)
                          : Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.value.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black.toOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      if (_selectedValue.id == item.value.id)
                        Icon(Icons.check, weight: 16.0),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
          child: Expanded(
            child: _valueSelectEmpty ? _buildHintText() : _buidHasValue(),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetPrefix() {
    return Row(
      children: [
        if (widget.isShowAssetPrefix) ...[
          widget.assetFile.isNotEmpty
              ? SizedBox(
                  width: 24,
                  child: widget.assetWidget,
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 8.0),
        ]
      ],
    );
  }

  Widget _buidHasValue() {
    return Row(
      children: [
        _buildAssetPrefix(),
        Expanded(
          child: Text(
            _selectedValue.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: widget.itemStyle ??
                TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: (widget.colorActiveItem ?? Colors.black)
                        .toOpacity(widget.enabled ? 1 : .6)),
          ),
        ),
      ],
    );
  }

  Widget _buildHintText() {
    return Row(
      children: [
        _buildAssetPrefix(),
        Text(
          widget.hintText,
          style: widget.hintTextStyle ??
              Theme.of(context).inputDecorationTheme.hintStyle,
        ),
      ],
    );
  }
}
