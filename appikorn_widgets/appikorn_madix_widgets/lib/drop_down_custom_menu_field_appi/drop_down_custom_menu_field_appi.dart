library drop_down_field_appi;

import 'package:flutter/material.dart';

import '../text_field_appi/text_field_appi.dart';
import '../utils/mode/text_field_params_appi.dart';

class DropDownCustomMenuFieldAppi extends StatefulWidget {
  final TextFieldParamsAppi textFieldStyle;
  final Widget Function(BuildContext context, void Function() closeOverlay) overlayBuilder;
  final Function(String?)? onChanged;

  /// Optional offset for the dropdown overlay position
  final Offset? overlayOffset;

  const DropDownCustomMenuFieldAppi({
    Key? key,
    required this.textFieldStyle,
    required this.overlayBuilder,
    this.onChanged,
    this.overlayOffset,
  }) : super(key: key);

  @override
  State<DropDownCustomMenuFieldAppi> createState() => _DropDownCustomMenuFieldAppiState();
}

class _DropDownCustomMenuFieldAppiState extends State<DropDownCustomMenuFieldAppi> with WidgetsBindingObserver {
  OverlayEntry? _overlayEntry;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.textFieldStyle.focus ?? FocusNode();
    WidgetsBinding.instance.addObserver(this); // Register observer
  }

  @override
  void dispose() {
    if (widget.textFieldStyle.focus == null) {
      _focusNode.dispose();
    }
    _overlayEntry?.remove();
    WidgetsBinding.instance.removeObserver(this); // Unregister observer
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called on layout/size changes (keyboard, resize, etc.)
    if (_overlayEntry != null) {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    // Unfocus the text field when showing the dropdown
    _focusNode.unfocus();
    
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);
    _overlayEntry?.remove();

    // Default vertical offset (-15.0 pixels to completely eliminate the gap)
    final double defaultVerticalOffset = -15.0;

    // Apply custom offset if provided, otherwise use the default negative offset
    final double leftPosition = offset.dx + (widget.overlayOffset?.dx ?? 0);
    final double topPosition = offset.dy + box.size.height + (widget.overlayOffset?.dy ?? defaultVerticalOffset);

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.loose,
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: leftPosition,
              top: topPosition,
              width: box.size.width,
              child: widget.overlayBuilder(context, _hideOverlay),
            ),
          ],
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldAppi(
      focus: _focusNode,
      widgetKey: widget.textFieldStyle.widgetKey,
      fillColor: widget.textFieldStyle.fillColor,
      readOnly: widget.textFieldStyle.readOnly,
      lable: widget.textFieldStyle.lable,
      mandatory: widget.textFieldStyle.mandatory,
      headingPaddingDown: widget.textFieldStyle.headingPaddingDown,
      textStyle: widget.textFieldStyle.textStyle,
      initialValue: widget.textFieldStyle.initialValue,
      onChanged: widget.onChanged,
      onTap: () {
        if (_overlayEntry == null) _showOverlay();
      },
    );
  }
}
