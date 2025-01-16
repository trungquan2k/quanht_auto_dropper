import 'package:flutter/material.dart';
import 'package:quanht_auto_dropper/config/config.index.dart';

import '../styles/auto_drop.style.dart';
import '../models/drop_item.dart';

class AutoDropOverLay<T> extends StatefulWidget {
  /// The list of dropdown items, where each item is represented as a `DropListWidget<T>`.
  final List<DropListWidget<T>> items;

  /// Called when a dropdown item is selected.
  /// Passes the selected `DropItem` object.
  final ValueChanged<DropItem>? onSelected;

  /// The main widget displayed as the child of the dropdown (e.g., button, label).
  final Widget child;

  /// The optional icon displayed alongside the dropdown; can be null.
  final Widget? iconDropdown;

  /// Controls the scrolling behavior of the parent widget.
  final ScrollController parentScrollController;

  /// Defines the styles for the dropdown button (e.g., size, color, padding).
  final AutoDropButtonStyle dropButtonStyle;

  /// Defines the styles for the dropdown menu (e.g., background color, shadow).
  final AutoDropStyle dropStyle;

  /// Determines if the dropdown is enabled for user interaction.
  /// If `false`, the dropdown is disabled.
  final bool enabled;

  /// If true, hides the dropdown icon.
  final bool hideIcon;

  const AutoDropOverLay({
    super.key,
    required this.items,
    required this.parentScrollController,
    required this.child,
    this.onSelected,
    this.iconDropdown,
    this.enabled = true,
    this.hideIcon = false,
    this.dropStyle = const AutoDropStyle(),
    this.dropButtonStyle = const AutoDropButtonStyle(),
  });

  @override
  State<AutoDropOverLay> createState() => _AutoDropOverLayState();
}

class _AutoDropOverLayState extends State<AutoDropOverLay>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _showAbove = false;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scrollListener();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _findPosition() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spaceAbove = position.dy;
    final double spaceBelow =
        screenHeight - (position.dy + renderBox.size.height);

    setState(() {
      _showAbove = spaceBelow < 200 && spaceAbove > spaceBelow;
    });
  }

  void _toggleDropdown({bool close = false}) async {
    _findPosition();
    if (widget.onSelected == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_isOpen || close) {
      await _controller.reverse();
      _overlayEntry?.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _isOpen = true);
      _controller.forward();
    }
  }

  _scrollListener() {
    widget.parentScrollController.addListener(() {
      if (_isOpen) {
        _toggleDropdown(close: true);
      }
    });
  }

  AutoDropButtonStyle get style => widget.dropButtonStyle;
  @override
  Widget build(BuildContext context) {
    final boxShadow = BoxShadow(
      color: Color(0xFFCDE2FE),
      blurRadius: 3,
      offset: const Offset(0, 1),
    );
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        key: _key,
        onTap: widget.enabled ? _toggleDropdown : null,
        child: Container(
          width: style.width ?? MediaQuery.of(context).size.width,
          height: style.height,
          padding: style.padding,
          decoration: BoxDecoration(
            color: (style.backgroundColor),
            boxShadow: widget.enabled ? style.boxShadow ?? [boxShadow] : [],
            border: style.border ?? Border.all(width: 1.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(style.radius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child,
              if (!widget.hideIcon)
                Transform.flip(
                  flipY: true,
                  child: widget.iconDropdown ??
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: widget.onSelected == null
                                  ? Colors.grey.toOpacity(0.6)
                                  : Colors.grey,
                              weight: 20.0,
                            )),
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double width = renderBox.size.width;
    final double height = renderBox.size.height;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                top: _showAbove
                    ? position.dy - widget.items.length * 54
                    : position.dy + height + 6,
                width: widget.dropStyle.width ?? width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: _showAbove
                      ? const Offset(0, -110)
                      : widget.dropStyle.offset ??
                          Offset(0, renderBox.size.height + 5),
                  child: Material(
                    elevation: widget.dropStyle.elevation,
                    color: (widget.items.isEmpty
                            ? Colors.grey
                            : widget.dropStyle.color)
                        ?.toOpacity(widget.enabled ? 1 : 0.6),
                    borderRadius: BorderRadius.circular(4),
                    shape: widget.dropStyle.shape,
                    child: widget.items.isEmpty
                        ? SizeTransition(
                            axisAlignment: 1,
                            sizeFactor: _expandAnimation,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Center(child: Text('No data')),
                                ],
                              ),
                            ),
                          )
                        : SizeTransition(
                            axisAlignment: 1,
                            sizeFactor: _expandAnimation,
                            child: RawScrollbar(
                              thumbVisibility: true,
                              thumbColor: widget.dropStyle.scrollbarColor ??
                                  Colors.grey,
                              controller: _scrollController,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                controller: _scrollController,
                                shrinkWrap: true,
                                children:
                                    widget.items.asMap().entries.map((item) {
                                  final response = item.value.value as DropItem;
                                  return InkWell(
                                    onTap: widget.onSelected != null
                                        ? () {
                                            widget.onSelected!(response);
                                            _toggleDropdown(close: true);
                                          }
                                        : null,
                                    child: item.value,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropListWidget<T> extends StatelessWidget {
  final T? value;
  final Widget child;

  const DropListWidget({super.key, this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
