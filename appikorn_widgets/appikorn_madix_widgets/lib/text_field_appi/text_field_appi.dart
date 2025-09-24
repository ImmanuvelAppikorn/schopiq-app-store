library appikorn_text_field;

import 'dart:async';
import 'dart:math';

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/utils/currency_input_formater.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:appikorn_madix_widgets/utils/global_validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../../utils/regx.dart';
import '../utils/mode/text_field_params_appi.dart';

/// Enum for currency codes
enum CurrencyCode {
  INR,
  QAR,
}

/// A customizable text field widget that supports various input validations and formatting options.
/// This widget is optimized for performance and provides a rich set of features including:
/// - Custom styling
/// - Input validation
/// - Input formatting
/// - Currency input
/// - Mobile number input
/// - Email input
class TextFieldAppi extends StatefulWidget {
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final String? lable;
  final String? initialValue;
  final String? hint;
  final Color? fillColor;
  final bool? allCaps;
  final bool? noSpace;
  final bool? counter;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final String? regx;
  final Function(String?)? onChanged;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onCompleted;
  final Widget? suffixIcon;
  final Widget? preffixxicon;
  final bool? readOnly;
  final bool? noFocus;
  final bool? mandatory;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final String? heading;
  final MainAxisAlignment? headingAlignment;
  final double? headingPaddingDown;
  final Style? headingTextStyle;
  final double? height;
  final bool? autofocus;
  final bool? currency;
  final bool? mobile;
  final bool? email;
  final bool? password;
  final FocusNode? focus;
  final TextEditingController? troller;
  final String? Function(String?)? validator;
  final GlobalKey<FormFieldState<String>> widgetKey;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focussedBorder;
  final OutlineInputBorder? errorBorder;
  final FocusNode? nextFocus;
  final bool? shiftNewLine;
  final TextStyle? hintTextStyle;
  final TextStyle? floatingLabelStyle;
  final String? countryCode;
  final CurrencyCode? currencyCode;
  final String? helpText;

  const TextFieldAppi({
    super.key,
    this.troller,
    required this.widgetKey,
    this.contentPadding,
    this.maxLines,
    this.maxLength,
    this.initialValue,
    this.hint,
    this.fillColor,
    this.allCaps,
    this.noSpace,
    this.counter,
    this.keyboardType,
    this.inputAction,
    this.regx,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.onCompleted,
    this.suffixIcon,
    this.preffixxicon,
    this.readOnly,
    this.noFocus,
    this.mandatory,
    this.errorText,
    this.heading,
    this.headingAlignment,
    this.headingPaddingDown,
    this.headingTextStyle,
    this.height,
    this.autofocus,
    this.currency,
    this.mobile,
    this.email,
    this.password,
    this.focus,
    this.validator,
    this.border,
    this.focussedBorder,
    this.errorBorder,
    this.lable,
    this.textStyle,
    this.nextFocus,
    this.shiftNewLine,
    this.hintTextStyle,
    this.floatingLabelStyle,
    this.countryCode,
    this.currencyCode,
    this.helpText,
  });

  /// Creates a TextFieldAppi instance from a parameter object
  factory TextFieldAppi.fromParams(TextFieldParamsAppi params) {
    return TextFieldAppi(
      widgetKey: params.widgetKey,
      lable: params.lable,
      maxLines: params.maxLines,
      maxLength: params.maxLength,
      textStyle: params.textStyle,
      initialValue: params.initialValue,
      hint: params.hint,
      fillColor: params.fillColor,
      allCaps: params.allCaps,
      noSpace: params.noSpace,
      counter: params.counter,
      keyboardType: params.keyboardType,
      inputAction: params.inputAction,
      regx: params.regx,
      onChanged: params.onChanged,
      onTap: params.onTap,
      onSaved: params.onSaved,
      onCompleted: params.onCompleted,
      suffixIcon: params.suffixIcon,
      preffixxicon: params.preffixxicon,
      readOnly: params.readOnly,
      noFocus: params.noFocus,
      mandatory: params.mandatory,
      contentPadding: params.contentPadding,
      errorText: params.errorText,
      heading: params.heading,
      headingAlignment: params.headingAlignment,
      headingPaddingDown: params.headingPaddingDown,
      headingTextStyle: params.headingTextStyle,
      height: params.height,
      autofocus: params.autofocus,
      currency: params.currency,
      mobile: params.mobile,
      email: params.email,
      password: params.password,
      focus: params.focus,
      troller: params.troller,
      validator: params.validator,
      border: params.border,
      focussedBorder: params.focussedBorder,
      errorBorder: params.errorBorder,
      nextFocus: params.nextFocus,
      shiftNewLine: params.shiftNewLine,
      hintTextStyle: params.hintTextStyle,
      floatingLabelStyle: params.floatingLabelStyle,
      countryCode: params.countryCode,
      currencyCode: params.currencyCode,
      helpText: params.helpText,
    );
  }

  @override
  State<TextFieldAppi> createState() => _TextFieldAppiState();
}

class _TextFieldAppiState extends State<TextFieldAppi> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = true;
  Timer? _debounceTimer;
  bool _isManuallyUpdating = false;
  bool _hasError = false;

  // Helper method to format currency values using CurrencyInputFormatter
  String _formatCurrencyValue(String value) {
    // Use the same formatter as in _buildInputFormatters
    final formatter = CurrencyInputFormatter(symbol: "", thousandsSeparator: ',');

    // Create a TextEditingValue with the raw value
    final oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue(text: value);

    // Apply the formatter
    final formattedValue = formatter.formatEditUpdate(oldValue, newValue);

    return formattedValue.text;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.troller ?? TextEditingController();
    _focusNode = widget.focus ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    // Set initial error state
    _hasError = widget.errorText?.isNotEmpty ?? false;

    // Set initial value after a frame to avoid focus issues
    if (widget.initialValue != null && _controller.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.currency == true) {
            // Format the initial value with currency formatting
            _controller.text = _formatCurrencyValue(widget.initialValue!);
          } else {
            _controller.text = widget.initialValue!;
          }
        }
      });
    }
  }

  void _onTypingStopped(String text) {
    if (widget.onCompleted != null) {
      // Trim leading spaces if present
      String processedText = text;
      if (processedText.startsWith(' ')) {
        processedText = processedText.trimLeft();
        // Update the controller text to reflect the trimmed value
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _controller.text = processedText;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          }
        });
      }
      
      if (widget.currency == true) {
        // Remove commas and currency symbols before passing to callback
        final cleanedText = processedText.replaceAll(RegExp(r'[,₹$€£¥]'), '');
        widget.onCompleted!(cleanedText);
      } else {
        widget.onCompleted!(processedText);
      }
    }
  }

  @override
  void didUpdateWidget(TextFieldAppi oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update error state when errorText changes
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _hasError = widget.errorText?.isNotEmpty ?? false;
      });
    }

    // Update focus node if needed
    if (widget.focus != oldWidget.focus) {
      if (oldWidget.focus == null) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      }
      _focusNode = widget.focus ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
    }

    // Update controller if needed
    if (widget.troller != oldWidget.troller) {
      if (oldWidget.troller == null) {
        _controller.dispose();
      }
      _controller = widget.troller ?? TextEditingController(text: widget.initialValue);
    } else if (widget.initialValue != oldWidget.initialValue && widget.troller == null) {
      // Schedule text update after the current build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.text != widget.initialValue) {
          if (widget.currency == true && widget.initialValue != null) {
            // Format the initial value with currency formatting
            _controller.text = _formatCurrencyValue(widget.initialValue!);
          } else {
            _controller.text = widget.initialValue ?? '';
          }
        }
      });
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      final hadFocus = _isFocused;
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }

    if (!_focusNode.hasFocus && widget.onSaved != null) {
      widget.onSaved!(_controller.text);
    }
  }

  void _handleTap() {
    if (!(widget.readOnly ?? false)) {
      _focusNode.requestFocus();
    }
    widget.onTap?.call();
  }

  void _handleSubmitted(String value) {
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    } else if (widget.inputAction == TextInputAction.next) {
      FocusScope.of(context).nextFocus();
    }

    if (widget.onSaved != null) {
      widget.onSaved!(value);
    }
  }

  /// Validates the input based on the field type and custom validator
  String? _switchValidator(String? s) {
    // Trim leading spaces if present
    String? trimmedValue = s;
    if (trimmedValue != null && trimmedValue.startsWith(' ')) {
      // If input starts with space, trim it and update controller
      final String trimmed = trimmedValue.trimLeft();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = trimmed;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      });
      trimmedValue = trimmed;
    }

    // Prefer custom validator if provided
    if (widget.validator != null) {
      final customResult = widget.validator!(trimmedValue);
      if (customResult != null && customResult.isNotEmpty) {
        setState(() => _hasError = true);
        return customResult;
      }
    }
    // Fallback to mandatory and built-in validators
    // Check if string is null, empty, or contains only whitespace
    if (trimmedValue == null || trimmedValue.isEmpty || trimmedValue.trim().isEmpty) {
      final result = widget.mandatory == true ? empty_validator(trimmedValue?.trim(), widget.lable ?? "") : null;
      setState(() => _hasError = result != null);
      return result;
    }
    if (widget.email == true) {
      final result = email_validator(trimmedValue);
      setState(() => _hasError = result != null);
      return result;
    }
    if (widget.mobile == true) {
      final result = mobile_validator(trimmedValue);
      setState(() => _hasError = result != null);
      return result;
    }
    setState(() => _hasError = false);
    return null;
  }

  /// Builds optimized input formatters based on field configuration
  List<TextInputFormatter> _buildInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if ((widget.maxLines ?? 1) > 1) {
      formatters.add(NewLineTextInputFormatter(maxLines: widget.maxLines ?? 1));
    }

    if (widget.currency == true) {
      formatters.add(CurrencyInputFormatter(symbol: "", thousandsSeparator: ','));
      return formatters;
    }

    if (widget.mobile == true) {
      // Only allow numbers for mobile input
      formatters.add(RegexInputFormatter(RegExp(r'[0-9]')));
      return formatters;
    }

    if (widget.regx != null) {
      try {
        formatters.add(RegexInputFormatter(RegExp(widget.regx!)));
      } catch (e) {
        debugPrint('Invalid regex pattern: ${widget.regx}');
        formatters.add(RegexInputFormatter(RegExp(allCharacterRegx)));
      }
    }

    // For email fields, allow alphanumeric, dots, @ and common email symbols
    if (widget.email == true) {
      // Don't add any filtering formatters for email - let the validator handle it
      // This ensures dots and all valid email characters are accepted
      formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s'))); // Just deny spaces
      return formatters;
    }

    if (widget.noSpace == true) {
      formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s')));
    }

    if (widget.allCaps == true) {
      formatters.add(UpperCaseTextFormatter());
    }

    return formatters;
  }

  /// Builds the label widget if label text is provided
  Widget? _buildLabel() {
    if (widget.lable == null) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Builder(builder: (context) {
            // Get the appropriate style based on focus state
            final bool isFocused = (_focusNode.hasFocus || _controller.text.isNotEmpty);

            // Choose the appropriate style based on focus state
            final TextStyle? themeStyle = isFocused ? (widget.floatingLabelStyle ?? Theme.of(context).inputDecorationTheme.floatingLabelStyle) : Theme.of(context).inputDecorationTheme.labelStyle;

            // Use null-safe approach with default values
            final color = themeStyle?.color ?? Colors.black;
            final fontSize = themeStyle?.fontSize ?? 14.0;
            final fontWeight = themeStyle?.fontWeight ?? FontWeight.normal;

            return TextAppi(
              mandatory: (widget.mandatory ?? false) && (widget.heading == null),
              text: widget.lable!,
              textStyle: Style.combine([
                Style($text.style.color(color)),
                Style($text.style.fontSize(fontSize)),
                Style($text.style.fontWeight(fontWeight)),
              ]),
            );
          }),
        )
      ],
    );
  }

  /// Builds the suffix icon if provided
  Widget? _buildSuffixIcon() {
    if (widget.password == true) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          if (mounted) {
            setState(() {
              _obscureText = !_obscureText;
            });
          }
        },
      );
    }
    return widget.suffixIcon ?? const SizedBox();
  }

  /// Builds the prefix icon based on field type
  Widget? _buildPrefixIcon() {
    if (widget.currency == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextAppi(
            text: widget.currencyCode == CurrencyCode.QAR ? "QAR" : "INR",
            textStyle: Style($text.style.fontSize(f0), $text.style.color.grey()),
          ),
        ],
      );
    }

    if (widget.mobile == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextAppi(
            text: widget.countryCode ?? "+91",
            textStyle: Style($text.style.fontSize(f0)),
          ),
        ],
      );
    }

    if (widget.preffixxicon == null) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        widget.preffixxicon!,
      ],
    );
  }

  /// Builds the text field with optimized decoration
  Widget _buildTextField() {
    final bool isMultiline = (widget.maxLines ?? 1) > 1;
    final bool shouldExpand = widget.height != null && isMultiline;

    // Prepare decoration with optimized rebuilds
    final InputDecoration decoration = InputDecoration(
      labelText: widget.lable != null && _buildLabel() == null ? widget.lable : null,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      hintText: widget.lable == null ? widget.hint : null,
      label: _buildLabel(),
      prefixIcon: _buildPrefixIcon(),
      suffixIcon: _buildSuffixIcon(),
      contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      border: widget.border ?? const OutlineInputBorder(),
      enabledBorder: widget.border,
      focusedBorder: widget.focussedBorder,
      errorBorder: widget.errorBorder,
      focusedErrorBorder: widget.errorBorder,
      disabledBorder: widget.border,
      filled: true,
      fillColor: widget.fillColor,
      errorStyle: const TextStyle(
        fontSize: f0,
        height: 1.2,
        overflow: TextOverflow.visible,
      ),
      errorMaxLines: 3,
      counterText: (widget.counter != true) ? "" : null,
      errorText: (widget.errorText?.isNotEmpty == true) ? widget.errorText : null,
      floatingLabelStyle: widget.floatingLabelStyle,
      hintStyle: widget.hintTextStyle,
    );

    int? effectiveMaxLines;
    int? effectiveMinLines;

    if (shouldExpand) {
      effectiveMaxLines = null;
      effectiveMinLines = null;
    } else {
      effectiveMaxLines = widget.maxLines;
      effectiveMinLines = isMultiline ? 1 : null;
    }

    // Add special handling for Enter key
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
        if (isMultiline && HardwareKeyboard.instance.isShiftPressed) {
          // Allow Shift+Enter to create a new line in multiline fields
          return KeyEventResult.ignored;
        } else if (isMultiline && !HardwareKeyboard.instance.isShiftPressed) {
          // Handle regular Enter as submission for multiline fields
          if (widget.onCompleted != null) {
            String text = _controller.text;
            if (text.startsWith(' ')) {
              text = text.trimLeft();
              // Update the controller text to reflect the trimmed value
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.text = text;
                }
              });
            }
            
            if (widget.currency == true) {
              // Remove commas and currency symbols before passing to callback
              final cleanedText = text.replaceAll(RegExp(r'[,₹$€£¥]'), '');
              widget.onCompleted!(cleanedText);
            } else {
              widget.onCompleted!(text);
            }
          }
          _focusNode.unfocus();
          return KeyEventResult.handled;
        } else if (!isMultiline) {
          // Handle Enter key for single-line fields - move to next field
          if (widget.onCompleted != null) {
            String text = _controller.text;
            if (text.startsWith(' ')) {
              text = text.trimLeft();
              // Update the controller text to reflect the trimmed value
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.text = text;
                }
              });
            }
            
            if (widget.currency == true) {
              // Remove commas and currency symbols before passing to callback
              final cleanedText = text.replaceAll(RegExp(r'[,₹$€£¥]'), '');
              widget.onCompleted!(cleanedText);
            } else {
              widget.onCompleted!(text);
            }
          }
          if (widget.onSaved != null) {
            widget.onSaved!(_controller.text);
          }
          // Move focus to next field
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          } else {
            FocusScope.of(context).nextFocus();
          }
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };

    Widget textField = TextFormField(
      style: widget.textStyle,
      controller: _controller,
      key: widget.widgetKey,
      validator: _switchValidator,
      focusNode: _focusNode,
      autofocus: widget.autofocus ?? false,
      onChanged: (s) {
        if (mounted) {
          // If text starts with space, trim it
          if (s.startsWith(' ')) {
            final trimmed = s.trimLeft();
            // Only update if there's a change to avoid infinite loop
            if (trimmed != s) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.text = trimmed;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              });
              s = trimmed;
            }
          }
          
          widget.widgetKey.currentState?.validate();
          widget.onChanged?.call(s);
          // Reset the timer on each change
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
            if (mounted) {
              _onTypingStopped(s);
            }
          });
        }
      },
      onTap: _handleTap,
      maxLength: widget.maxLength ?? ((widget.maxLines ?? 1) > 1 ? 1000 : 100),
      maxLines: effectiveMaxLines,
      minLines: effectiveMinLines,
      expands: shouldExpand,
      inputFormatters: _buildInputFormatters(),
      textCapitalization: TextCapitalization.words,
      keyboardType: isMultiline ? TextInputType.multiline : (widget.keyboardType ?? TextInputType.text),
      textAlignVertical: TextAlignVertical.top,
      textInputAction: isMultiline ? TextInputAction.newline : TextInputAction.done,
      onFieldSubmitted: (s) {
        if (!isMultiline) {
          if (widget.onSaved != null) {
            widget.onSaved!(s);
          }
          if (widget.onCompleted != null) {
            if (widget.currency == true) {
              // Remove commas and currency symbols before passing to callback
              final cleanedText = s.replaceAll(RegExp(r'[,₹$€£¥]'), '');
              widget.onCompleted!(cleanedText);
            } else {
              widget.onCompleted!(s);
            }
          }
          FocusScope.of(context).nextFocus();
        }
      },
      readOnly: widget.readOnly ?? false,
      obscureText: widget.password == true ? _obscureText : false,
      decoration: decoration,
      onSaved: widget.onSaved,
    );

    if (widget.height != null) {
      textField = SizedBox(
        // height: widget.height,
        child: textField,
      );
    }

    // Use a StatefulBuilder to rebuild when the form field state changes
    return StatefulBuilder(
      builder: (context, setState) {
        // Check if the field is currently showing an error
        final bool hasError = widget.widgetKey.currentState?.hasError ?? false || (widget.errorText?.isNotEmpty ?? false);

        return Column(
          children: [
            textField,
            if (!hasError)
              const SizedBox(
                height: 18,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.heading?.isNotEmpty == true) ...[
          Row(
            mainAxisAlignment: widget.headingAlignment ?? MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextAppi(
                  mandatory: widget.mandatory ?? false,
                  selectable: false,
                  text: widget.heading!,
                  textStyle: Style.combine([
                    Style($text.style.fontWeight(w400), $text.maxLines(10), $text.style.fontSize(f1)),
                  ]).merge(widget.headingTextStyle ?? const Style.empty()),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.headingPaddingDown ?? 0),
        ],
        _buildTextField(),
      ],
    );

    if (widget.noFocus ?? false) {
      content = ExcludeFocusTraversal(child: content);
    }

    // Add tooltip if helpText is provided
    if (widget.helpText != null && widget.helpText!.isNotEmpty) {
      content = CustomTooltip(
        message: widget.helpText!,
        waitDuration: const Duration(seconds: 2),
        child: content,
      );
    }

    // Wrap in Material for proper web rendering
    return Material(
      color: Colors.transparent,
      child: content,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    // Clean up focus node if we own it
    if (widget.focus == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }

    // Clean up controller if we own it
    if (widget.troller == null && _controller.hasListeners) {
      _controller.dispose();
    }

    super.dispose();
  }
}

/// Custom input formatter that prevents invalid characters without clearing existing text
class RegexInputFormatter extends TextInputFormatter {
  final RegExp allowedPattern;

  RegexInputFormatter(this.allowedPattern);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, allow it (for deletion)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Check if the new character(s) match the allowed pattern
    final String newText = newValue.text;
    final String oldText = oldValue.text;
    
    // If text is being deleted, allow it
    if (newText.length < oldText.length) {
      return newValue;
    }
    
    // Check each character in the new text
    bool isValid = true;
    for (int i = 0; i < newText.length; i++) {
      if (!allowedPattern.hasMatch(newText[i])) {
        isValid = false;
        break;
      }
    }
    
    // If all characters are valid, allow the change
    if (isValid) {
      return newValue;
    }
    
    // If invalid characters are found, keep the old value
    return oldValue;
  }
}

/// Text formatter that handles newline input
class NewLineTextInputFormatter extends TextInputFormatter {
  final int maxLines;

  NewLineTextInputFormatter({required this.maxLines});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Count existing newlines
    final currentLines = '\n'.allMatches(newValue.text).length + 1;

    // If we haven't reached maxLines, allow the newline
    if (currentLines <= maxLines) {
      return newValue;
    }

    // Otherwise, keep the old value
    return oldValue;
  }
}

/// A custom tooltip that shows after a delay on hover and dynamically positions itself
class CustomTooltip extends StatefulWidget {
  final String message;
  final Duration waitDuration;
  final Widget child;

  const CustomTooltip({
    Key? key,
    required this.message,
    this.waitDuration = const Duration(seconds: 1),
    required this.child,
  }) : super(key: key);

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with SingleTickerProviderStateMixin {
  bool _isTooltipVisible = false;
  final GlobalKey _toolTipKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_isTooltipVisible) return;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isTooltipVisible = true);
  }

  void _hideTooltip() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() => _isTooltipVisible = false);
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      // Return an empty overlay entry if renderBox is null
      return OverlayEntry(builder: (context) => const SizedBox.shrink());
    }

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Calculate available space
    final screenSize = MediaQuery.of(context).size;
    final rightSpace = screenSize.width - offset.dx - size.width;
    final leftSpace = offset.dx;

    // Determine tooltip position (prefer right if space available)
    final showOnRight = rightSpace >= 200 || (rightSpace > leftSpace);

    // Calculate tooltip position
    final double positionLeft = showOnRight ? offset.dx + size.width + 5 : max(5.0, offset.dx - 200);

    // Calculate vertical position - center with the field
    final double positionTop = offset.dy + (size.height / 2) - 12;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: positionLeft,
        top: positionTop,
        child: Material(
          elevation: 4,
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _toolTipKey,
      onEnter: (event) {
        _timer?.cancel();
        _timer = Timer(widget.waitDuration, _showTooltip);
      },
      onExit: (event) {
        _timer?.cancel();
        _hideTooltip();
      },
      child: widget.child,
    );
  }
}

/// Text formatter that converts input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}