library searchable_text_field_appi;

import 'dart:io';

import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/circle_loader_appi/circle_loader_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mix/mix.dart';

import '../../utils/global_size.dart';
import '../../utils/global_validations.dart';
import '../../utils/regx.dart';
import '../text_appi/text_appi.dart';
import '../utils/mode/text_field_params_appi.dart';
import 'dropdown_menu_dependency.dart';

class SearchableTextFieldAppi extends StatefulWidget {
  const SearchableTextFieldAppi({
    super.key,
    required this.context,
    required this.list,
    this.dropdownColor,
    this.focussedSuffixicon,
    this.bottomSheetHeight,
    this.onlyDropDown,
    this.radius,
    this.dropdownHeight,
    this.offset,
    this.bottomsheetTitle,
    this.imageList,
    this.colorList,
    this.dropdownTextStyle,
    required this.onChanged,
    this.dropdownTextColor,
    required this.textFieldStyle,
    this.textSize,
  });

  final Color? dropdownColor;
  final BuildContext context;
  final Color? dropdownTextColor;
  final Style? dropdownTextStyle;
  final Widget? focussedSuffixicon;
  final bool? onlyDropDown;
  final List<String> list;
  final List<String>? imageList;
  final List<String>? colorList;
  final void Function(String?) onChanged;
  final double? bottomSheetHeight;
  final double? radius;
  final double? textSize;
  final double? dropdownHeight;
  final Offset? offset;
  final String? bottomsheetTitle;
  final TextFieldParamsAppi textFieldStyle;

  @override
  State<SearchableTextFieldAppi> createState() => _SearchableTextFieldAppiState();
}

class _SearchableTextFieldAppiState extends State<SearchableTextFieldAppi> {
  late final TextEditingController searchController;
  late final TextEditingController mainTextController;
  late FocusNode _focusNode;
  bool _isMenuOpen = false;
  bool _hasSelectedValue = false;
  late FormFieldState<String>? _fieldState;

  void ifMounted(VoidCallback callback) {
    if (mounted) callback();
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    mainTextController = TextEditingController();
    _focusNode = widget.textFieldStyle.focus ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    if (widget.textFieldStyle.initialValue != null && widget.textFieldStyle.initialValue!.isNotEmpty) {
      _hasSelectedValue = true;
      mainTextController.text = widget.textFieldStyle.initialValue!;
    }
  }

  @override
  void didUpdateWidget(SearchableTextFieldAppi oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update text and selection state when initialValue changes
    if (widget.textFieldStyle.initialValue != oldWidget.textFieldStyle.initialValue) {
      ifMounted(() {
        setState(() {
          mainTextController.text = widget.textFieldStyle.initialValue ?? '';
          _hasSelectedValue = widget.textFieldStyle.initialValue?.isNotEmpty ?? false;
        });
      });
    }
  }

  @override
  void dispose() {
    // Remove listener before disposal
    if (_focusNode.hasListeners) {
      _focusNode.removeListener(_handleFocusChange);
    }

    // Only dispose focus node if we created it
    if (widget.textFieldStyle.focus == null) {
      _focusNode.dispose();
    }

    // Safely dispose controllers
    // ignore: invalid_use_of_protected_member
    if (!searchController.hasListeners) {
      searchController.dispose();
    }

    if (!mainTextController.hasListeners) {
      mainTextController.dispose();
    }

    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && !_isMenuOpen) {
      ifMounted(() => setState(() => _isMenuOpen = true));
    } else if (!_focusNode.hasFocus && _isMenuOpen) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_focusNode.hasFocus) return;
        ifMounted(() => setState(() => _isMenuOpen = false));
      });
    }
  }

  void showModel() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    ifMounted(() => setState(() => _isMenuOpen = true));
  }

  void _clearSelection() {
    ifMounted(() {
      setState(() {
        mainTextController.clear();

        _hasSelectedValue = false;
        _isMenuOpen = false;
      });
      widget.onChanged('');
      if (_fieldState != null) {
        _fieldState!.didChange(null);
        _fieldState!.validate();
      }
    });
  }

  void _handleItemSelection(String selectedValue) {
    ifMounted(() {
      setState(() {
        mainTextController.text = selectedValue;
        _hasSelectedValue = true;
        _isMenuOpen = false;
      });
      widget.onChanged(selectedValue);
      _fieldState!.validate();
    });
  }

  Widget bottomSheet() {
    return Column(
      children: [
        if (widget.textFieldStyle.heading != null && widget.textFieldStyle.heading!.isNotEmpty)
          Row(
            mainAxisAlignment: widget.textFieldStyle.headingAlignment ?? MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextAppi(
                    mandatory: widget.textFieldStyle.mandatory ?? false,
                    selectable: false,
                    text: widget.textFieldStyle.heading!,
                    textStyle: Style.combine([
                      Style($text.style.fontWeight(w500), $text.maxLines(1), $text.style.fontSize(f0)),
                    ]).merge(widget.textFieldStyle.headingTextStyle ?? const Style.empty())),
              ),
            ],
          ),
        SizedBox(
          height: widget.textFieldStyle.headingPaddingDown ?? 0,
        ),
        TextFieldAppi(
          troller: mainTextController,
          focus: _focusNode,
          textStyle: widget.textFieldStyle.textStyle,
          widgetKey: (!kIsWeb && (widget.onlyDropDown == null || (widget.onlyDropDown ?? false))) ? widget.textFieldStyle.widgetKey : GlobalKey<FormFieldState<String>>(),
          errorText: widget.textFieldStyle.errorText,
          contentPadding: widget.textFieldStyle.contentPadding,
          hint: widget.textFieldStyle.hint,
          suffixIcon: _hasSelectedValue
              ? GestureDetector(
                  onTap: _clearSelection,
                  child: const Icon(Icons.cancel, size: 20),
                )
              : widget.textFieldStyle.suffixIcon == null
                  ? const Icon(Icons.arrow_drop_down)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        widget.textFieldStyle.suffixIcon ?? Container(),
                      ],
                    ),
          preffixxicon: widget.textFieldStyle.preffixxicon == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    widget.textFieldStyle.preffixxicon ?? Container(),
                  ],
                ),
          readOnly: widget.textFieldStyle.readOnly ?? false,
          lable: widget.textFieldStyle.lable ?? (((widget.textFieldStyle.mandatory ?? false) && widget.textFieldStyle.heading == null) ? "*" : ""),
          regx: noSymbolregex,
          onTap: showModel,
          onChanged: (value) {
            if (value != mainTextController.text) {
              ifMounted(() {
                setState(() {
                  _hasSelectedValue = value != null && value.isNotEmpty;
                });
                widget.onChanged(value ?? '');
              });
            }
          },
        ),
      ],
    );
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

  String? switchValidator(String? s) {
    if (s != null && s.isNotEmpty) {
      return null;
    }

    if (widget.textFieldStyle.validator != null) {
      return widget.textFieldStyle.validator!(s);
    } else if (widget.textFieldStyle.mandatory ?? false) {
      return empty_validator(s, widget.textFieldStyle.lable ?? "");
    }
    return null;
  }

  Widget bottomSheetCard({required int index}) {
    return !(widget.list[index].toLowerCase().trim().contains(searchController.text.toLowerCase().trim()))
        ? const SizedBox()
        : InkWell(
            onTap: () => _handleItemSelection(widget.list[index]),
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 17, bottom: 17),
                    child: Row(
                      children: [
                        if (widget.imageList != null && widget.imageList!.isNotEmpty) ...[
                          SizedBox(
                            width: s2,
                          ),
                          svgImageLoad(index: index)
                        ],
                        if (widget.colorList != null && widget.colorList!.isNotEmpty) ...[
                          SizedBox(
                            width: s2,
                          ),
                          if (widget.colorList![index].contains(",")) ...[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: BoxAppi(
                                radius: 5,
                                gradientColor: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                                  Color(int.parse(widget.colorList![index].split(",")[0], radix: 16) + 0xFF000000),
                                  Color(int.parse(widget.colorList![index].split(",")[1], radix: 16) + 0xFF000000),
                                ]),
                                child: Container(),
                              ),
                            )
                          ] else ...[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: BoxAppi(
                                radius: 5,
                                fillColor: Color(int.parse(widget.colorList![index].split(",")[0] == "Nil" ? "000000" : widget.colorList![index].split(",")[0], radix: 16) + 0xFF000000),
                                child: Container(),
                              ),
                            )
                          ]
                        ],
                        SizedBox(
                          width: s1,
                        ),
                        Flexible(
                          child: TextAppi(
                            selectable: false,
                            textStyle: Style.combine([
                              Style($text.style.fontWeight(w400), $text.maxLines(3), $text.style.fontSize(3)),
                            ]),
                            text: widget.list[index],
                          ),
                        ),
                        SizedBox(
                          width: s1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    child: Divider(
                      height: 0.5,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    mainTextController.text = widget.textFieldStyle.initialValue ?? "";
    return (kIsWeb || (widget.onlyDropDown != null && widget.onlyDropDown == true)) ? dropDownWidget() : bottomSheet();
  }

  InputDecorationTheme theme() {
    return InputDecorationTheme(
        contentPadding: Theme.of(context).inputDecorationTheme.contentPadding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        filled: true,
        isDense: true,
        errorStyle: const TextStyle(
          fontSize: f0,
          height: 0.9,
          color: Colors.red, // Explicitly set error color
        ),
        fillColor: Colors.white,
        border: widget.textFieldStyle.border,
        enabledBorder: widget.textFieldStyle.border,
        focusedBorder: widget.textFieldStyle.focussedBorder,
        errorBorder: widget.textFieldStyle.errorBorder);
  }

  Widget trailingIcon() {
    return _hasSelectedValue
        ? GestureDetector(
            onTap: _clearSelection,
            child: const Icon(Icons.cancel, size: 20),
          )
        : const Icon(Icons.arrow_drop_down, opticalSize: 1);
  }

  Widget dropDownWidget() {
    return FormField<String>(
      key: (kIsWeb || (widget.onlyDropDown != null && widget.onlyDropDown == true)) ? widget.textFieldStyle.widgetKey : null,
      validator: switchValidator,
      initialValue: widget.textFieldStyle.initialValue,
      builder: (FormFieldState<String> field) {
        _fieldState = field;
        return Column(
          children: [
            if (widget.textFieldStyle.heading != null && widget.textFieldStyle.heading!.isNotEmpty)
              Row(
                mainAxisAlignment: widget.textFieldStyle.headingAlignment ?? MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextAppi(
                        mandatory: widget.textFieldStyle.mandatory ?? false,
                        selectable: false,
                        text: widget.textFieldStyle.heading!,
                        textStyle: Style.combine([
                          Style($text.style.fontWeight(w500), $text.maxLines(1), $text.style.fontSize(f0)),
                        ]).merge(widget.textFieldStyle.headingTextStyle ?? const Style.empty())),
                  ),
                ],
              ),
            SizedBox(
              height: widget.textFieldStyle.headingPaddingDown ?? 0,
            ),
            DropdownMenuAppikorn(
                enabled: (widget.textFieldStyle.readOnly == true) ? false : true,
                controller: mainTextController,
                requestFocusOnTap: true,
                menuHeight: 200,
                hintText: widget.textFieldStyle.hint,
                errorText: field.errorText,
                onSelected: (value) {
                  if (kDebugMode) {
                    print("onselected");
                  }
                  ifMounted(() {
                    setState(() {
                      _hasSelectedValue = value != null && value.isNotEmpty;
                    });
                  });

                  widget.onChanged(value ?? '');
                  field.didChange(value);
                  field.validate();
                },
                trailingIcon: Focus(focusNode: _focusNode, child: trailingIcon()),
                inputDecorationTheme: theme(),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.white; // Keep white background in all states
                    },
                  ),
                ),
                textStyle: TextStyle(color: widget.dropdownTextColor, fontSize: widget.textSize ?? f0, fontWeight: w400),
                selectedTrailingIcon: trailingIcon(),
                expandedInsets: EdgeInsets.symmetric(horizontal: 0, vertical: widget.offset?.dy ?? -10), // Use the offset parameter to adjust the gap
                leadingIcon: widget.textFieldStyle.preffixxicon == null
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          widget.textFieldStyle.preffixxicon ?? Container(),
                        ],
                      ),
                label: TextAppi(
                  text: widget.textFieldStyle.lable ?? '',
                  textStyle: Style.combine([
                    Style(
                      $text.style.fontSize(f0),
                      $text.style.color(Theme.of(context).colorScheme.primary),
                    ),
                  ]),
                  mandatory: ((widget.textFieldStyle.mandatory ?? false) && widget.textFieldStyle.heading == null),
                ),
                dropdownMenuEntries: <DropdownMenuEntryAppikorn<String>>[
                  if (mounted) ...[
                    for (var k = 0; k < widget.list.length; k++)
                      DropdownMenuEntryAppikorn(value: widget.list[k], label: widget.list[k], trailingIcon: (widget.imageList != null && widget.imageList!.isNotEmpty) ? svgImageLoad(index: k) : null)
                  ]
                ]),
          ],
        );
      },
    );
  }
}

class CachedSvgImage extends StatefulWidget {
  final String imageUrl;

  const CachedSvgImage({super.key, required this.imageUrl});

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

  Future<String> _loadSvg(String url) async {
    try {
      File? cachedFile = await DefaultCacheManager().getSingleFile(url);
      return await cachedFile.readAsString();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading SVG: $e");
      }
      return ""; // Return empty string on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _svgString,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder(); // Loading indicator placeholder
        } else if (snapshot.hasError || (snapshot.data?.isEmpty ?? true)) {
          // Show a fallback icon instead of error text
          return const Icon(Icons.image_not_supported, size: 20);
        } else {
          try {
            return SvgPicture.string(
              snapshot.data ?? '',
              placeholderBuilder: (context) => placeholder(),
            );
          } catch (e) {
            // Handle SVG parsing errors
            if (kDebugMode) {
              print("Error parsing SVG: $e");
            }
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
          child: CircleLoaderAppi(
            size: 14,
          )),
    );
  }
}
