import 'dart:async';
import 'package:flutter/material.dart';

class DropdownEditingController<T> extends ChangeNotifier {
  T? _value;
  
  DropdownEditingController({T? value}) : _value = value;
  
  T? get value => _value;
  
  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }
}

class DropdownFormField<T> extends StatefulWidget {
  final bool autoFocus;
  final bool Function(T item, String str)? filterFn;
  final Future<List<T>> Function(String str) findFn;
  final String Function(T item) displayItemFn;
  final InputDecoration? decoration;
  final Color? dropdownColor;
  final DropdownEditingController<T>? controller;
  final void Function(T? item)? onChanged;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final TextInputType? keyboardType;
  final Offset? offset;

  const DropdownFormField({
    Key? key,
    required this.findFn,
    required this.displayItemFn,
    this.autoFocus = false,
    this.filterFn,
    this.decoration,
    this.dropdownColor,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.offset,
  }) : super(key: key);

  @override
  State<DropdownFormField<T>> createState() => _DropdownFormFieldState<T>();
}

class _DropdownFormFieldState<T> extends State<DropdownFormField<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  late final DropdownEditingController<T> _controller;
  Timer? _debounce;
  List<T> _items = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DropdownEditingController<T>();
    _searchController.addListener(() => _onSearchChanged(_searchController.text));
    _focusNode.addListener(_onFocusChanged);
    _loadInitialItems();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _searchController.removeListener(() => _onSearchChanged(_searchController.text));
    _removeOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      // Add a small delay before removing the overlay to ensure proper cleanup
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted || _focusNode.hasFocus) return;
        _removeOverlay();
      });
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ListTile(
                          title: Text(widget.displayItemFn(item)),
                          selected: _controller.value == item,
                          onTap: () {
                            _controller.value = item;
                            _searchController.text = widget.displayItemFn(item);
                            widget.onChanged?.call(item);
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _loadInitialItems() async {
    setState(() => _isLoading = true);
    try {
      _items = await widget.findFn('');
      setState(() {});
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      
      setState(() => _isLoading = true);
      try {
        final results = await widget.findFn(value);
        if (widget.filterFn != null) {
          _items = results.where((item) => 
            widget.filterFn!(item, value)
          ).toList();
        } else {
          _items = results;
        }
        setState(() {});
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (FormFieldState<T> field) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: (widget.decoration ?? const InputDecoration()).copyWith(
              filled: true,
              fillColor: widget.dropdownColor ?? Colors.white,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.value != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.value = null;
                        _searchController.clear();
                        widget.onChanged?.call(null);
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                      } else {
                        _focusNode.requestFocus();
                      }
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              if (!_focusNode.hasFocus) {
                _focusNode.requestFocus();
              }
            },
            onChanged: _onSearchChanged,
          ),
        );
      },
    );
  }
}
