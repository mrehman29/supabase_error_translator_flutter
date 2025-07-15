import 'package:supabase_error_translator_flutter/src/data/translations/cn.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/de.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/en.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/es.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/fr.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/jp.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/kr.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/pl.dart';
import 'package:supabase_error_translator_flutter/src/data/translations/pt.dart';
import 'package:supabase_error_translator_flutter/src/models/error_service.dart';
import 'package:supabase_error_translator_flutter/src/models/supported_language.dart';

/// Translation data structure containing all error messages for different languages and services.
class TranslationData {
  /// Map of language codes to their translation maps.
  static const Map<String, Map<String, dynamic>> _translations = {
    'en': englishTranslations,
    'de': germanTranslations,
    'es': spanishTranslations,
    'fr': frenchTranslations,
    'jp': japaneseTranslations,
    'kr': koreanTranslations,
    'pl': polishTranslations,
    'pt': portugueseTranslations,
    'cn': chineseTranslations,
  };

  /// Get translation for a specific error code.
  static String? getTranslation(
    SupportedLanguage language,
    ErrorService service,
    String errorCode,
  ) {
    final langCode = language.code;
    final serviceName = service.name;

    return _translations[langCode]?['services']?[serviceName]?[errorCode];
  }

  /// Get the unknown error message for a specific language.
  static String getUnknownErrorMessage(SupportedLanguage language) {
    return _translations[language.code]?['unknown_error'] ?? _translations['en']!['unknown_error']!;
  }

  /// Check if a language is supported.
  static bool isLanguageSupported(String languageCode) {
    return _translations.containsKey(languageCode);
  }

  /// Get all supported language codes.
  static List<String> getSupportedLanguages() {
    return _translations.keys.toList();
  }
}
