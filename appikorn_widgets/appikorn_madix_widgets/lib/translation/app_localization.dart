import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. AppLocalizations Class
class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  // Helper method to access the AppLocalizations instance from the context
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Delegate for this AppLocalizations class
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  // Load the language JSON file from the "lib/core/languages/" folder
  Future<bool> load() async {
    // Ensuring the path matches your structure: lib/core/languages/ar.json
    String fileName;
    if (locale.languageCode == 'ar') {
      fileName = 'arabic.json'; // Use the specific filename for Arabic
    } else {
      fileName = '${locale.languageCode}.json';
    }
    String jsonString =
    await rootBundle.loadString('lib/core/languages/$fileName');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    // Return the key itself if not found, or a placeholder like 'Translation not found'
    return _localizedStrings[key] ?? key;
  }
}

// 2. _AppLocalizationsDelegate Class
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't hold state),
  // so we can define it as a const constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    // For now, we only support Arabic.
    return ['ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// 3. Optional but convenient: Extension for easier access in widgets
extension AppLocalizationsExtension on BuildContext {
  String tr(String key) {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      // This might happen if AppLocalizations is not found in the context,
      // e.g., if the delegate isn't set up correctly or accessed too early.
      // Returning the key as a fallback.
      // Consider logging an error or using a more descriptive placeholder.
      print("Warning: AppLocalizations.of(context) returned null for key '$key'. Ensure AppLocalizations.delegate is in MaterialApp's localizationsDelegates and context is valid.");
      return key;
    }
    return localizations.translate(key);
  }
}