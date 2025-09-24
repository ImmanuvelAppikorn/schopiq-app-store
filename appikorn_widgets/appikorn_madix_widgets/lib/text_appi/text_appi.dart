library text_appi;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../translation/app_localization.dart';

/// Currency types supported by TextAppi
enum CurrencyType {
  qar,
  inr,
}

extension CurrencyTypeExtension on CurrencyType {
  String get symbol {
    switch (this) {
      case CurrencyType.qar:
        return 'QAR';
      case CurrencyType.inr:
        return '₹';
    }
  }

  String get code {
    switch (this) {
      case CurrencyType.qar:
        return 'QAR';
      case CurrencyType.inr:
        return 'INR';
    }
  }

  NumberFormat formatter({int? decimalDigits}) {
    switch (this) {
      case CurrencyType.qar:
        return NumberFormat.currency(
          locale: 'en_US',
          symbol: '',
          decimalDigits: decimalDigits,
        );
      case CurrencyType.inr:
        return NumberFormat.currency(
          locale: 'en_IN',
          symbol: '',
          decimalDigits: decimalDigits,
        );
    }
  }
}

class TextAppi extends StatelessWidget {
  /// Creates a TextAppi widget.
  ///
  /// If [amount] is provided, the [text] parameter becomes optional
  /// and the widget will display formatted currency text. If [currencyType] is not provided,
  /// it defaults to [CurrencyType.qar].
  ///
  /// If [amount] is not provided, the [text] parameter is required.
  const TextAppi({
    Key? key,
    this.text,
    this.mandatory = false,
    this.selectable = false,
    this.textStyle,
    this.autoSize = false,
    this.minFontSize,
    this.responsiveSize = true,
    this.baseWidth = 1920, // Base design width (typical desktop design width)
    this.amount,
    this.currencyType,
    this.showDecimalPlaces = false,
  })  : assert((text != null) || (amount != null), 'Either text must be provided or amount must be provided'),
        super(key: key);

  final String? text;
  final bool mandatory;
  final bool selectable;
  final Style? textStyle;
  final bool autoSize;
  final double? minFontSize;
  final bool responsiveSize; // Whether to apply responsive sizing
  final double baseWidth; // Base width used in design
  final num? amount; // Optional amount for currency formatting
  final CurrencyType? currencyType; // Optional currency type
  final bool showDecimalPlaces; // Whether to show decimal places in currency format

  // Format text with currency if amount is provided
  String _getFormattedText() {
    if (amount != null) {
      // Use QAR as default currency if not specified
      final currency = currencyType ?? CurrencyType.qar;

      // Check if the amount has non-zero decimal part
      final hasNonZeroDecimal = (amount! - amount!.truncate()) != 0;

      // Use decimal places based on configuration and decimal value
      // Show decimal places if explicitly requested or if there's a non-zero decimal part
      final decimalDigits = showDecimalPlaces || hasNonZeroDecimal ? 2 : 0;

      final formattedAmount = currency
          .formatter(
            decimalDigits: decimalDigits,
          )
          .format(amount);

      // Trim any extra spaces that might be added by the formatter
      return '${currency.symbol} ${formattedAmount.trim()}';
    }
    return text ?? '';
  }

  // Calculate responsive font size based on screen width
  double _getResponsiveFontSize(BuildContext context, double fontSize) {
    if (!responsiveSize) return fontSize;

    // Get the current screen width and device orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Apply different scaling for different device categories
    double scaleFactor;

    if (screenWidth < 600) {
      // Mobile phones - apply more aggressive scaling
      scaleFactor = (screenWidth / baseWidth) * 0.85; // Additional 15% reduction for small screens
    } else if (screenWidth < 900) {
      // Tablets in portrait mode - slightly reduced scaling
      scaleFactor = (screenWidth / baseWidth) * 0.9; // Additional 10% reduction
    } else if (screenWidth < 1200) {
      // Tablets in landscape or small laptops
      scaleFactor = (screenWidth / baseWidth) * 0.95; // Additional 5% reduction
    } else {
      // Desktops and large displays
      scaleFactor = (screenWidth / baseWidth);
    }

    // Further adjust scaling based on orientation for small devices
    if (isLandscape && screenWidth < 900) {
      scaleFactor *= 0.95; // Additional 5% reduction in landscape for better fit
    }

    // Apply scaling with constraints to prevent text from becoming too small or too large
    final scaledSize = fontSize * scaleFactor;

    // Ensure font size stays within reasonable bounds, with tighter constraints
    return scaledSize.clamp(
        fontSize * 0.65, // Lower minimum bound (65% of original size)
        fontSize * 1.2 // Lower maximum bound (120% of original size)
        );
  }

  @override
  Widget build(BuildContext context) {
    // Default style
    Style defaultStyle = Style.combine([Style()]);
    final mergedStyle = defaultStyle.merge(textStyle ?? const Style.empty());

    // Default font size to use if we can't determine it from the style
    final double defaultFontSize = 14.0;

    // Apply responsive sizing to the default font size
    final responsiveFontSize = _getResponsiveFontSize(context, defaultFontSize);

    // Create a responsive style with the calculated font size
    final responsiveStyle = Style.combine([
      Style($text.style.fontSize(responsiveFontSize)),
      mergedStyle,
    ]);

    // Get the formatted text (with currency if applicable)
    final displayText = _getFormattedText();

    final txt_localized = AppLocalizations.of(context)?.translate(displayText) ?? displayText;
    Widget txt() {
      if (autoSize) {
        // Use FittedBox with Mix styling for auto-responsive text
        return Box(
          style: responsiveStyle,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: StyledText(txt_localized, style: const Style.empty()),
          ),
        );
      }
      return StyledText(txt_localized, style: responsiveStyle);
    }

    Widget mainTxt() {
      return mandatory
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                txt(),
                StyledText(
                  " *",
                  style: Style.combine([
                    Style($text.style.color.red()),
                    Style($text.style.fontSize(responsiveFontSize)),
                  ]),
                )
              ],
            )
          : txt();
    }

    return RepaintBoundary(
      child: ExcludeFocusTraversal(
        child: selectable
            ? SelectionArea(
                child: mainTxt(),
              )
            : mainTxt(),
      ),
    );
  }
}

// Extension to provide responsive text utilities
extension ResponsiveTextExtension on BuildContext {
  // Get a scaling factor based on design width and device category
  double getScaleFactor({double baseWidth = 1920}) {
    final screenWidth = MediaQuery.of(this).size.width;
    final isLandscape = MediaQuery.of(this).orientation == Orientation.landscape;

    // Apply different scaling for different device categories
    double scaleFactor;

    if (screenWidth < 600) {
      // Mobile phones - apply more aggressive scaling
      scaleFactor = (screenWidth / baseWidth) * 0.85; // Additional 15% reduction for small screens
    } else if (screenWidth < 900) {
      // Tablets in portrait mode - slightly reduced scaling
      scaleFactor = (screenWidth / baseWidth) * 0.9; // Additional 10% reduction
    } else if (screenWidth < 1200) {
      // Tablets in landscape or small laptops
      scaleFactor = (screenWidth / baseWidth) * 0.95; // Additional 5% reduction
    } else {
      // Desktops and large displays
      scaleFactor = (screenWidth / baseWidth);
    }

    // Further adjust scaling based on orientation for small devices
    if (isLandscape && screenWidth < 900) {
      scaleFactor *= 0.95; // Additional 5% reduction in landscape for better fit
    }

    return scaleFactor;
  }

  // Calculate a responsive size with improved scaling
  double responsiveSize(double size, {double baseWidth = 1920}) {
    final scaleFactor = getScaleFactor(baseWidth: baseWidth);
    return (size * scaleFactor).clamp(size * 0.65, size * 1.2);
  }
}
