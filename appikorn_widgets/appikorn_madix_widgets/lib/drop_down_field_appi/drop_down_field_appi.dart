library drop_down_field_appi;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

import '../circle_loader_appi/circle_loader_appi.dart';
import '../text_field_appi/text_field_appi.dart';
import '../utils/mode/text_field_params_appi.dart';

// Navigation shortcuts to move the selected menu items up or down
Map<ShortcutActivator, Intent> _kDropdownTraversalShortcuts = <ShortcutActivator, Intent>{
  LogicalKeySet(LogicalKeyboardKey.arrowUp): const _ArrowUpIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowDown): const _ArrowDownIntent(),
};

// Singleton manager to ensure only one dropdown is open at a time
class _DropdownManager {
  static final _DropdownManager _instance = _DropdownManager._internal();
  factory _DropdownManager() => _instance;
  _DropdownManager._internal();

  _DropDownFieldAppiState? _activeDropdown;

  void register(_DropDownFieldAppiState dropdown) {
    if (_activeDropdown != null && _activeDropdown != dropdown) {
      _activeDropdown!._hideDropdown();
    }
    _activeDropdown = dropdown;
  }

  void unregister(_DropDownFieldAppiState dropdown) {
    if (_activeDropdown == dropdown) {
      _activeDropdown = null;
    }
  }
}

class _ArrowUpIntent extends Intent {
  const _ArrowUpIntent();
}

class _ArrowDownIntent extends Intent {
  const _ArrowDownIntent();
}

class DropDownFieldAppi extends StatefulWidget {
  final List<String> items;
  final TextFieldParamsAppi textFieldStyle;
  final Function(String?)? onChanged;
  final Color? dropdownColor;
  final Color? dropdownTextColor;
  final double? expandedFieldHeight;
  final double? borderRadius;
  final TextStyle? itemTextStyle;
  final bool loading;
  final bool useBottomSheetOnMobile;
  final List<String>? imageList;
  final Function(String)? onFilterTextChanged;

  const DropDownFieldAppi({
    Key? key,
    required this.items,
    required this.textFieldStyle,
    required this.onChanged,
    this.dropdownColor,
    this.dropdownTextColor,
    this.expandedFieldHeight,
    this.borderRadius,
    this.itemTextStyle,
    this.loading = false,
    this.useBottomSheetOnMobile = true,
    this.imageList,
    this.onFilterTextChanged,
  }) : super(key: key);

  @override
  State<DropDownFieldAppi> createState() => _DropDownFieldAppiState();
}

class _DropDownFieldAppiState extends State<DropDownFieldAppi> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusNode _bottomSheetSearchFocusNode = FocusNode();
  final TextEditingController _bottomSheetSearchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];
  int _selectedIndex = -1;
  bool _isDropdownOpen = false;
  final ScrollController _scrollController = ScrollController();
  FormFieldState<String>? _fieldState;
  bool _isKeyboardSelection = false;
  Color? _cachedTextColor;
  final _dropdownManager = _DropdownManager();
  bool _isClosingDropdown = false;
  int _hoveredIndex = -1;
  String _lastValidSelection = '';
  bool _hasPendingSelection = false;
  String? _pendingSelectionValue;

  // Get the image for a specific item
  String? _getImageForItem(String item) {
    if (widget.imageList == null) return null;

    final int originalIndex = widget.items.indexOf(item);
    if (originalIndex >= 0 && originalIndex < widget.imageList!.length) {
      return widget.imageList![originalIndex];
    }
    return null;
  }

  Widget svgImageLoad({required int index}) {
    if (widget.imageList == null || index >= widget.imageList!.length) {
      return const SizedBox(width: 25, height: 25);
    }

    return (mounted)
        ? SizedBox(
            width: 25,
            height: 25,
            child: CachedSvgImage(
              imageUrl: widget.imageList![index],
            ),
          )
        : const SizedBox(
            width: 25,
            height: 25,
          );
  }

  @override
  void initState() {
    super.initState();
    _lastValidSelection = widget.textFieldStyle.initialValue ?? '';
    _textController = widget.textFieldStyle.troller ?? TextEditingController();
    if (widget.textFieldStyle.initialValue != null && widget.textFieldStyle.initialValue!.isNotEmpty) {
      _textController.text = widget.textFieldStyle.initialValue!;
    }
    _focusNode = widget.textFieldStyle.focus ?? FocusNode();
    _focusNode.addListener(_handleFocusNodeChange);
    _filteredItems = List.from(widget.items);

    if (widget.textFieldStyle.initialValue != null && widget.textFieldStyle.initialValue!.isNotEmpty) {
      _textController.text = widget.textFieldStyle.initialValue!;
      for (int i = 0; i < _filteredItems.length; i++) {
        if (_filteredItems[i] == widget.textFieldStyle.initialValue) {
          _selectedIndex = i;
          break;
        }
      }
    }
  }

  @override
  void didUpdateWidget(DropDownFieldAppi oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If items list changed, update the mapping
    if (!listEquals(widget.items, oldWidget.items)) {}

    if (widget.textFieldStyle.initialValue != oldWidget.textFieldStyle.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textController.text = widget.textFieldStyle.initialValue ?? '';
          _selectedIndex = widget.textFieldStyle.initialValue != null ? _filteredItems.indexOf(widget.textFieldStyle.initialValue!) : -1;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cachedTextColor = Theme.of(context).textTheme.bodyMedium?.color;
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_handleFocusNodeChange);
    if (widget.textFieldStyle.focus == null) {
      _focusNode.dispose();
    }
    _keyboardListenerFocusNode.dispose();
    _bottomSheetSearchController.dispose();
    _bottomSheetSearchFocusNode.dispose();
    _overlayEntry?.remove();
    _dropdownManager.unregister(this);
    super.dispose();
  }

  void _handleFocusNodeChange() {
    if (_focusNode.hasFocus && !_isDropdownOpen && !widget.loading) {
      _showDropdownOrBottomSheet();
    } else if (!_focusNode.hasFocus && _isDropdownOpen) {
      _hideDropdown();
    } else if (!_focusNode.hasFocus) {
      _validateAndResetIfNeeded();
    }
  }

  void _validateAndResetIfNeeded() {
    final currentText = _textController.text;

    if (currentText.isEmpty) {
      _lastValidSelection = '';

      if (widget.onChanged != null) {
        widget.onChanged!(null);
      }

      if (_fieldState != null) {
        _fieldState!.didChange(null);
      }

      return;
    }

    bool isValid = widget.items.contains(currentText);

    if (!isValid) {
      print('DEBUG: Invalid text entered: "$currentText", resetting to: "$_lastValidSelection"');

      _textController.text = _lastValidSelection;

      if (_fieldState != null) {
        _fieldState!.didChange(_lastValidSelection);
      }
    }
  }

  void _hideDropdown() {
    if (_overlayEntry != null) {
      // Track if onChanged was called
      bool onChangedCalled = false;

      if (_hasPendingSelection) {
        // Process the selection first
        final String selectedValue = _pendingSelectionValue!;

        // Call onChanged first
        if (widget.onChanged != null) {
          widget.onChanged!(selectedValue);
          onChangedCalled = true;
        }

        // Update last valid selection
        _lastValidSelection = selectedValue;

        // Clear the pending flag
        _hasPendingSelection = false;
      } else {
        // No explicit selection - validate the current text
        final currentText = _textController.text;
        bool isValid = widget.items.contains(currentText);

        // If text is different from last valid selection, we need to validate
        if (currentText != _lastValidSelection) {
          if (!isValid) {
            print('DEBUG: Invalid text entered: "$currentText", resetting to: "$_lastValidSelection"');

            // Reset to last valid selection
            _textController.text = _lastValidSelection;

            // Update form state if needed
            if (_fieldState != null) {
              _fieldState!.didChange(_lastValidSelection);
            }
          } else {
            // Text is valid but different from last selection, so call onChanged
            if (widget.onChanged != null) {
              widget.onChanged!(currentText);
              onChangedCalled = true;
            }
            _lastValidSelection = currentText;
          }
        }
      }

      // Print debug message if onChanged was not called during dropdown closure
      if (!onChangedCalled) {
        print('hurreyy - dropdown closed without calling onChanged');
      }

      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isDropdownOpen = false;
      });

      // Unregister this dropdown when it's hidden
      _dropdownManager.unregister(this);
    }
  }

  void _updateSelection(int index) {
    setState(() {
      _selectedIndex = index;
      if (_isDropdownOpen) {
        _textController.text = _filteredItems[_selectedIndex];
        _textController.selection = TextSelection.collapsed(offset: _textController.text.length);
        _scrollController.animateTo(
          max(0, _selectedIndex * 48.0 - (_scrollController.position.viewportDimension / 2) + (48.0 / 2)),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
    if (_isDropdownOpen && _overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (_isDropdownOpen && event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _hideDropdown();
      } else if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_selectedIndex >= 0 && _selectedIndex < _filteredItems.length) {
          final selectedValue = _filteredItems[_selectedIndex];
          _textController.text = selectedValue;
          _isKeyboardSelection = true;
          _handleItemSelection(selectedValue);
          _hideDropdown();
          if (widget.textFieldStyle.nextFocus != null) {
            widget.textFieldStyle.nextFocus?.requestFocus();
          }
        }
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedIndex < 0 || !_scrollController.hasClients) return;

    const itemHeight = 48.0;
    final visibleHeight = widget.expandedFieldHeight ?? 200.0;
    final targetOffset = _selectedIndex * itemHeight;
    final currentOffset = _scrollController.offset;
    final maxOffset = _scrollController.position.maxScrollExtent;

    final idealOffset = max(0, min(maxOffset, targetOffset - (visibleHeight / 2) + (itemHeight / 2))).toDouble();

    if (targetOffset < currentOffset || targetOffset > currentOffset + visibleHeight - itemHeight) {
      _scrollController.animateTo(
        idealOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showDropdownOrBottomSheet() {
    if (widget.loading) return;

    setState(() {
      _filteredItems = List.from(widget.items);
    });

    String? selectedItem = _textController.text.isNotEmpty ? _textController.text : null;
    if (selectedItem != null && _filteredItems.contains(selectedItem)) {
      int currentIndex = _filteredItems.indexOf(selectedItem);
      _filteredItems.removeAt(currentIndex);
      _filteredItems.insert(0, selectedItem);
      _selectedIndex = 0;
    } else {
      _selectedIndex = -1;
    }

    _dropdownManager.register(this);

    if (widget.useBottomSheetOnMobile && _isMobileWidth()) {
      _showBottomSheet();
    } else {
      _showDropdown();
    }
  }

  bool _isMobileWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600;
  }

  void _showBottomSheet() {
    if (widget.loading) return;

    _dropdownManager.register(this);

    setState(() {
      _filteredItems = List.from(widget.items);
      _isDropdownOpen = true;
    });

    String? selectedItem = _textController.text.isNotEmpty ? _textController.text : null;

    if (selectedItem != null && _filteredItems.contains(selectedItem)) {
      int currentIndex = _filteredItems.indexOf(selectedItem);
      _filteredItems.removeAt(currentIndex);
      _filteredItems.insert(0, selectedItem);
    }

    _bottomSheetSearchController.clear();

    // Ensure keyboard is dismissed
    FocusManager.instance.primaryFocus?.unfocus();

    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true, // Use safe area to handle notches/home indicators better
      backgroundColor: Colors.white,
      // Use more explicit shape with tighter corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      // Force the builder to be called only once to prevent rebuild issues
      barrierColor: Colors.black54, // Slightly darker barrier for better visibility
      builder: (BuildContext context) {
        return PopScope(
          // Use PopScope instead of WillPopScope for newer Flutter versions
          canPop: true,
          onPopInvoked: (didPop) {
            // Ensure keyboard is dismissed
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.2, // Even smaller min size for easier dismissal
            maxChildSize: 0.9,
            expand: false,
            snap: true, // Add snapping behavior
            snapSizes: const [0.2, 0.7], // Fix: First snap value must match minChildSize
            builder: (context, scrollController) {
              return StatefulBuilder(builder: (context, setModalState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Future.delayed(const Duration(milliseconds: 150), () {
                  //   if (_bottomSheetSearchFocusNode.canRequestFocus) {
                  //     _bottomSheetSearchFocusNode.requestFocus();
                  //   }
                  // });
                });

                return Column(
                  children: [
                    // More prominent drag handle
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[400], // Darker for better visibility
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Search field with reduced padding
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0), // Reduced top padding
                      child: TextField(
                        controller: _bottomSheetSearchController,
                        focusNode: _bottomSheetSearchFocusNode,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: widget.textFieldStyle.hint,
                          // Tighter padding around the search icon
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 4, 0), // Reduced right padding
                            child: Icon(Icons.search, size: 20), // Smaller icon
                          ),
                          // Remove extra content padding
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          _filterItemsForBottomSheet(value, setModalState);
                        },
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                    // List content
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: scrollController,
                        child: ListView.separated(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(), // Always allow scrolling
                          itemCount: _filteredItems.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                              indent: 20,
                              endIndent: 20,
                            );
                          },
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final isSelected = item == _textController.text;
                            final isHovered = _hoveredIndex == index;

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque, // Make entire area tappable
                              onTap: () {
                                // Immediate unfocus
                                FocusManager.instance.primaryFocus?.unfocus();

                                // Clear the selection now and close sheet
                                _handleItemSelectionFromBottomSheet(item);

                                // Force pop the navigation context
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  setModalState(() {
                                    _hoveredIndex = index;
                                  });
                                },
                                onExit: (_) {
                                  setModalState(() {
                                    _hoveredIndex = -1;
                                  });
                                },
                                child: Container(
                                  color: isHovered ? Colors.grey.withOpacity(0.2) : (isSelected ? Colors.grey.withOpacity(0.1) : null),
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: widget.itemTextStyle?.copyWith(
                                                color: widget.dropdownTextColor,
                                                fontWeight: isSelected ? FontWeight.bold : null,
                                              ) ??
                                              TextStyle(
                                                color: widget.dropdownTextColor ?? Colors.black,
                                                fontWeight: isSelected ? FontWeight.bold : null,
                                              ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 18.0,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              });
            },
          ),
        );
      },
    ).then((_) {
      // Ensure cleanup happens reliably after bottom sheet closes
      if (mounted) {
        setState(() {
          _isDropdownOpen = false;
        });
        _dropdownManager.unregister(this);

        // Ensure any lingering focus is cleared
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  void _filterItemsForBottomSheet(String query, StateSetter setModalState) {
    List<String> items = List.from(widget.items);
    String? selectedItem = _textController.text.isNotEmpty ? _textController.text : null;

    List<String> newFilteredItems;
    if (query.isEmpty) {
      newFilteredItems = items;
    } else {
      newFilteredItems = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    }

    if (selectedItem != null && newFilteredItems.contains(selectedItem)) {
      newFilteredItems.remove(selectedItem);
      newFilteredItems.insert(0, selectedItem);
    }

    int highlightIndex = -1;
    if (newFilteredItems.length == 1) {
      highlightIndex = 0;
    }

    setModalState(() {
      _filteredItems = newFilteredItems;
      _hoveredIndex = highlightIndex;
    });

    if (widget.onFilterTextChanged != null) {
      widget.onFilterTextChanged!(query);
    }
  }

  void _handleItemSelectionFromBottomSheet(String value) {
    final String oldValue = _textController.text;
    final bool isDeselection = value == oldValue && !_isKeyboardSelection;

    final bool matchesInitialValue = widget.textFieldStyle.initialValue != null && value == widget.textFieldStyle.initialValue;

    setState(() {
      if (isDeselection && matchesInitialValue) {
        _textController.clear();
      } else {
        _textController.text = value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _hideDropdown();

        if (widget.textFieldStyle.nextFocus != null) {
          widget.textFieldStyle.nextFocus?.requestFocus();
        }
      }
    });

    if (isDeselection && matchesInitialValue) {
      widget.onChanged?.call("");
      if (_fieldState != null) {
        _fieldState!.didChange("");
        _fieldState!.validate();
      }
      if (widget.textFieldStyle.widgetKey.currentState != null) {
        widget.textFieldStyle.widgetKey.currentState!.didChange("");
        widget.textFieldStyle.widgetKey.currentState!.validate();
      }
    } else {
      widget.onChanged?.call(value);
      if (_fieldState != null) {
        _fieldState!.didChange(value);
        _fieldState!.validate();
      }
      if (widget.textFieldStyle.widgetKey.currentState != null) {
        widget.textFieldStyle.widgetKey.currentState!.didChange(value);
        widget.textFieldStyle.widgetKey.currentState!.validate();
      }
    }
  }

  void _showDropdown() {
    if (widget.loading) return;

    _dropdownManager.register(this);

    setState(() {
      _filteredItems = List.from(widget.items);
      _isDropdownOpen = true;
    });

    String? selectedItem = _textController.text.isNotEmpty ? _textController.text : null;
    if (selectedItem != null && _filteredItems.contains(selectedItem)) {
      int currentIndex = _filteredItems.indexOf(selectedItem);
      _filteredItems.removeAt(currentIndex);
      _filteredItems.insert(0, selectedItem);
      _selectedIndex = 0;
    } else {
      _selectedIndex = -1;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenBottom = screenHeight - MediaQuery.of(context).viewInsets.bottom;

    final spaceBelow = screenBottom - (position.dy + size.height);
    final spaceAbove = position.dy;

    final dropdownHeight = min(widget.expandedFieldHeight ?? 200.0, _filteredItems.length * 48.0 + 2.0);
    final showBelow = spaceBelow >= dropdownHeight || spaceBelow >= spaceAbove;

    final topVerticalOffset = -8.0;
    final bottomVerticalOffset = 8.0;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideDropdown,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: position.dx,
            width: size.width,
            top: showBelow ? position.dy + size.height + topVerticalOffset : null,
            bottom: showBelow ? null : screenHeight - position.dy + bottomVerticalOffset,
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(4),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: min(
                    dropdownHeight,
                    showBelow ? spaceBelow : spaceAbove,
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemExtent: 48.0,
                    itemBuilder: (context, index) => _buildDropdownItem(_filteredItems[index], index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _hasPendingSelection = false;
  }

  void _handleItemSelection(String value) {
    final String oldValue = _textController.text;
    final bool isDeselection = value == oldValue && !_isKeyboardSelection;

    final bool matchesInitialValue = widget.textFieldStyle.initialValue != null && value == widget.textFieldStyle.initialValue;

    setState(() {
      if (isDeselection && matchesInitialValue) {
        _textController.clear();
        _selectedIndex = -1;
      } else {
        _textController.text = value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _hideDropdown();

        if (widget.textFieldStyle.nextFocus != null) {
          widget.textFieldStyle.nextFocus?.requestFocus();
        }
      }
    });

    if (isDeselection && matchesInitialValue) {
      widget.onChanged?.call("");
      if (_fieldState != null) {
        _fieldState!.didChange("");
        _fieldState!.validate();
      }
      if (widget.textFieldStyle.widgetKey.currentState != null) {
        widget.textFieldStyle.widgetKey.currentState!.didChange("");
        widget.textFieldStyle.widgetKey.currentState!.validate();
      }
    } else {
      widget.onChanged?.call(value);
      if (_fieldState != null) {
        _fieldState!.didChange(value);
        _fieldState!.validate();
      }
      if (widget.textFieldStyle.widgetKey.currentState != null) {
        widget.textFieldStyle.widgetKey.currentState!.didChange(value);
        widget.textFieldStyle.widgetKey.currentState!.validate();
      }

      _isKeyboardSelection = false;
    }
  }

  void _superDirectSelection(String item) {
    _isClosingDropdown = true;

    try {
      _lastValidSelection = item;

      if (widget.onChanged != null) {
        print('DEBUG: Calling onChanged directly for: $item');
        widget.onChanged!(item);
      }

      _textController.value = TextEditingValue(
        text: item,
        selection: TextSelection.collapsed(offset: item.length),
      );

      if (_fieldState != null) {
        _fieldState!.didChange(item);
        _fieldState!.validate();
      }

      if (widget.textFieldStyle.widgetKey.currentState != null) {
        widget.textFieldStyle.widgetKey.currentState!.didChange(item);
        widget.textFieldStyle.widgetKey.currentState!.validate();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (_overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;

            setState(() {
              _isDropdownOpen = false;
            });

            _dropdownManager.unregister(this);

            if (widget.textFieldStyle.nextFocus != null) {
              widget.textFieldStyle.nextFocus?.requestFocus();
            }
          }

          _isClosingDropdown = false;
        }
      });
    } catch (e) {
      _isClosingDropdown = false;
      print('ERROR in dropdown selection: $e');
    }
  }

  Widget _buildDropdownItem(String item, int index) {
    final bool isSelected = item == _textController.text;
    final bool isHovered = _hoveredIndex == index;

    final String? imageUrl = _getImageForItem(item);
    final bool hasImage = imageUrl != null;

    return Listener(
      onPointerDown: (event) {
        if (!_isClosingDropdown) {
          print('DEBUG: Pointer down on item: $item');
          _superDirectSelection(item);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hoveredIndex = index;
          });
          _overlayEntry?.markNeedsBuild();
        },
        onExit: (_) {
          setState(() {
            _hoveredIndex = -1;
          });
          _overlayEntry?.markNeedsBuild();
        },
        child: Container(
          color: isHovered ? Colors.grey.withOpacity(0.2) : (isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              if (hasImage)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CachedSvgImage(
                    imageUrl: imageUrl!,
                  ),
                ),
              Expanded(
                child: Text(
                  item,
                  style: (widget.itemTextStyle ??
                          TextStyle(
                            color: widget.dropdownTextColor ?? _cachedTextColor,
                            fontSize: 16.0,
                          ))
                      .copyWith(
                    fontWeight: isSelected ? FontWeight.w500 : null,
                    color: isSelected ? Colors.grey[800] : widget.dropdownTextColor ?? _cachedTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 18.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _filterItems(List<String> items, {String? filterText}) {
    setState(() {
      List<String> filteredItems = List.from(items);
      String? selectedItem = _textController.text.isNotEmpty ? _textController.text : null;

      if (filterText != null && filterText.isNotEmpty) {
        filteredItems = filteredItems.where((item) => item.toLowerCase().contains(filterText.toLowerCase())).toList();
      }

      if (selectedItem != null && filteredItems.contains(selectedItem)) {
        filteredItems.remove(selectedItem);
        filteredItems.insert(0, selectedItem);
      }

      if (filteredItems.length == 1) {
        _selectedIndex = 0;
      } else {
        _selectedIndex = -1;
      }

      _filteredItems = filteredItems;
    });

    _overlayEntry?.markNeedsBuild();
  }

  void _handleTextChange() {
    final text = _textController.text;
    if (!_isDropdownOpen) return;

    if (text.isNotEmpty) {
      _filterItems(widget.items, filterText: text);

      if (widget.onFilterTextChanged != null) {
        widget.onFilterTextChanged!(text);
      }
    } else {
      _filterItems(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _kDropdownTraversalShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          _ArrowUpIntent: CallbackAction<_ArrowUpIntent>(
            onInvoke: (intent) {
              if (_isDropdownOpen) {
                _isKeyboardSelection = true;
                _updateSelection(_selectedIndex <= 0 ? _filteredItems.length - 1 : _selectedIndex - 1);
                return null;
              } else {
                _showDropdownOrBottomSheet();
                return null;
              }
            },
          ),
          _ArrowDownIntent: CallbackAction<_ArrowDownIntent>(
            onInvoke: (intent) {
              if (_isDropdownOpen) {
                _isKeyboardSelection = true;
                _updateSelection(_selectedIndex >= _filteredItems.length - 1 ? 0 : _selectedIndex + 1);
                return null;
              } else {
                _showDropdownOrBottomSheet();
                return null;
              }
            },
          ),
        },
        child: KeyboardListener(
          focusNode: _keyboardListenerFocusNode,
          onKeyEvent: _handleKeyEvent,
          child: FormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: widget.textFieldStyle.initialValue,
            validator: widget.textFieldStyle.validator,
            onSaved: widget.textFieldStyle.onSaved,
            builder: (FormFieldState<String> state) {
              _fieldState = state;
              return TextFieldAppi(
                troller: _textController,
                focus: _focusNode,
                initialValue: widget.textFieldStyle.initialValue,
                nextFocus: widget.textFieldStyle.nextFocus,
                inputAction: widget.textFieldStyle.inputAction,
                textStyle: widget.textFieldStyle.textStyle,
                hint: widget.textFieldStyle.hint,
                lable: widget.textFieldStyle.lable,
                mandatory: widget.textFieldStyle.mandatory,
                fillColor: widget.textFieldStyle.fillColor,
                readOnly: widget.loading,
                helpText: widget.textFieldStyle.helpText,
                onChanged: (value) {
                  if (!widget.loading) {
                    _handleTextChange();
                  }
                  state.didChange(value);
                },
                onCompleted: (value) {
                  if (!widget.loading && _selectedIndex >= 0 && _isKeyboardSelection) {
                    _handleItemSelection(_filteredItems[_selectedIndex]);
                  }
                },
                widgetKey: widget.textFieldStyle.widgetKey,
                suffixIcon: widget.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleLoaderAppi(size: 14),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (!widget.loading && !_isDropdownOpen) {
                            _showDropdownOrBottomSheet();
                          }
                        },
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                onTap: () {
                  if (!widget.loading && !_isDropdownOpen) {
                    _showDropdownOrBottomSheet();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class CachedSvgImage extends StatefulWidget {
  final String imageUrl;

  const CachedSvgImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  CachedSvgImageState createState() => CachedSvgImageState();
}

class CachedSvgImageState extends State<CachedSvgImage> {
  late Future<String> _svgString;

  @override
  void initState() {
    super.initState();
    _svgString = _loadSvg(widget.imageUrl);
  }

  @override
  void didUpdateWidget(CachedSvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _svgString = _loadSvg(widget.imageUrl);
      });
    }
  }

  Future<String> _loadSvg(String url) async {
    if (url.isEmpty) {
      return "";
    }

    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      if (file.existsSync()) {
        return await file.readAsString();
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _svgString,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder();
        } else if (snapshot.hasError || (snapshot.data?.isEmpty ?? true)) {
          return const Icon(Icons.image_not_supported, size: 20);
        } else {
          try {
            return SvgPicture.string(
              snapshot.data ?? '',
              placeholderBuilder: (context) => placeholder(),
            );
          } catch (e) {
            return const Icon(Icons.image_not_supported, size: 20);
          }
        }
      },
    );
  }

  Widget placeholder() {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircleLoaderAppi(size: 14),
      ),
    );
  }
}
