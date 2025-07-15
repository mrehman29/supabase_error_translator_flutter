import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:supabase_error_translator_flutter/src/data/translation_data.dart';
import 'package:supabase_error_translator_flutter/src/exceptions/translator_exception.dart';
import 'package:supabase_error_translator_flutter/src/models/error_service.dart';
import 'package:supabase_error_translator_flutter/src/models/supported_language.dart';
import 'package:supabase_error_translator_flutter/src/models/translation_result.dart';

/// Main class for translating Supabase error codes into localized messages.
///
/// This class provides a comprehensive solution for translating Supabase error
/// codes and messages into multiple languages, with support for both apps that
/// use Flutter's internationalization features and single-language apps.
class SupabaseErrorTranslator {
  static SupportedLanguage _currentLanguage = SupportedLanguage.en;
  static bool _autoDetectLanguage = false;

  /// Sets the current language for translations.
  ///
  /// [language] can be a [SupportedLanguage] enum value or a string language code.
  /// If [autoDetect] is true, the translator will attempt to detect the device's
  /// language automatically.
  ///
  /// Example:
  /// ```dart
  /// SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);
  /// // or
  /// SupabaseErrorTranslator.setLanguage('es');
  /// // or with auto-detection
  /// SupabaseErrorTranslator.setLanguage(null, autoDetect: true);
  /// ```
  static void setLanguage(
    dynamic language, {
    bool autoDetect = false,
  }) {
    _autoDetectLanguage = autoDetect;

    if (autoDetect) {
      _currentLanguage = _detectDeviceLanguage();
    } else if (language is SupportedLanguage) {
      _currentLanguage = language;
    } else if (language is String) {
      _currentLanguage = SupportedLanguageExtension.fromCode(language);
    } else if (language != null) {
      throw TranslatorException(
        'Invalid language type. Expected SupportedLanguage or String, got ${language.runtimeType}',
      );
    }
  }

  /// Attempts to detect the device's language automatically.
  ///
  /// This method works with both Flutter apps that use internationalization
  /// and single-language apps. It falls back to English if the device language
  /// is not supported.
  static SupportedLanguage _detectDeviceLanguage() {
    try {
      // Try to get locale from Flutter's internationalization
      if (WidgetsBinding.instance.platformDispatcher.locale.languageCode.isNotEmpty) {
        final deviceLanguage = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
        return SupportedLanguageExtension.fromCode(deviceLanguage);
      }

      // Fallback to platform-specific detection
      if (!kIsWeb) {
        final platformLocale = Platform.localeName;
        final languageCode = platformLocale.split('_').first;
        return SupportedLanguageExtension.fromCode(languageCode);
      }
    } on Exception catch (e) {
      // If detection fails, fall back to English
      debugPrint('Failed to detect device language: $e');
    }

    return SupportedLanguage.en;
  }

  /// Gets the currently active language.
  ///
  /// If auto-detection is enabled, this will return the detected language.
  /// Otherwise, it returns the manually set language.
  static SupportedLanguage getCurrentLanguage() {
    if (_autoDetectLanguage) {
      return _detectDeviceLanguage();
    }
    return _currentLanguage;
  }

  /// Gets all supported language codes.
  ///
  /// Returns a list of ISO language codes that are supported by the translator.
  ///
  /// Example:
  /// ```dart
  /// final languages = SupabaseErrorTranslator.getSupportedLanguages();
  /// print(languages); // ['en', 'de', 'es', 'fr', 'jp', 'kr', 'pl', 'pt', 'cn']
  /// ```
  static List<String> getSupportedLanguages() {
    return SupportedLanguageExtension.allCodes;
  }

  /// Translates a Supabase error code into a localized message.
  ///
  /// [errorCode] is the error code from Supabase. If null or empty, it will be
  /// treated as 'unknown_error'.
  ///
  /// [service] specifies which Supabase service generated the error.
  ///
  /// [language] can optionally override the current language for this specific
  /// translation. It can be a [SupportedLanguage] enum value, a string language
  /// code, or 'auto' for automatic detection.
  ///
  /// The method follows a four-step fallback chain:
  /// 1. Service-specific locale lookup
  /// 2. Service-specific English lookup
  /// 3. Generic locale fallback
  /// 4. Generic English fallback
  ///
  /// Example:
  /// ```dart
  /// final result = SupabaseErrorTranslator.translateErrorCode(
  ///   'email_not_confirmed',
  ///   ErrorService.auth,
  /// );
  /// print(result.message); // Localized error message
  /// ```
  static TranslationResult translateErrorCode(
    String? errorCode,
    ErrorService service, {
    dynamic language,
  }) {
    // Normalize error code
    final normalizedCode = (errorCode?.trim().isEmpty ?? true) ? 'unknown_error' : errorCode!.trim();

    // Determine target language
    SupportedLanguage targetLanguage;
    if (language == 'auto') {
      targetLanguage = _detectDeviceLanguage();
    } else if (language is SupportedLanguage) {
      targetLanguage = language;
    } else if (language is String) {
      targetLanguage = SupportedLanguageExtension.fromCode(language);
    } else {
      targetLanguage = getCurrentLanguage();
    }

    // Step 1: Service-specific locale lookup
    String? translation = TranslationData.getTranslation(
      targetLanguage,
      service,
      normalizedCode,
    );

    if (translation != null) {
      return TranslationResult(
        message: translation,
        language: targetLanguage,
        originalCode: errorCode,
      );
    }

    // Step 2: Service-specific English lookup
    if (targetLanguage != SupportedLanguage.en) {
      translation = TranslationData.getTranslation(
        SupportedLanguage.en,
        service,
        normalizedCode,
      );

      if (translation != null) {
        return TranslationResult.fallback(
          message: translation,
          language: SupportedLanguage.en,
          originalCode: errorCode,
        );
      }
    }

    // Step 3: Generic locale fallback
    final genericMessage = TranslationData.getUnknownErrorMessage(targetLanguage);
    if (genericMessage.isNotEmpty) {
      return TranslationResult.fallback(
        message: genericMessage,
        language: targetLanguage,
        originalCode: errorCode,
      );
    }

    // Step 4: Generic English fallback
    final fallbackMessage = TranslationData.getUnknownErrorMessage(SupportedLanguage.en);
    return TranslationResult.fallback(
      message: fallbackMessage,
      language: SupportedLanguage.en,
      originalCode: errorCode,
    );
  }

  /// Convenience method to translate an error code and return just the message.
  ///
  /// This is a simplified version of [translateErrorCode] that returns only
  /// the translated message string instead of a [TranslationResult] object.
  ///
  /// Example:
  /// ```dart
  /// final message = SupabaseErrorTranslator.translate(
  ///   'invalid_credentials',
  ///   ErrorService.auth,
  /// );
  /// print(message); // "Invalid login credentials" (in current language)
  /// ```
  static String translate(
    String? errorCode,
    ErrorService service, {
    dynamic language,
  }) {
    final result = translateErrorCode(errorCode, service, language: language);
    return result.message;
  }

  /// Enables or disables automatic language detection.
  ///
  /// When enabled, the translator will automatically detect the device's
  /// language and use it for translations. When disabled, the translator
  /// will use the manually set language.
  ///
  /// Example:
  /// ```dart
  /// SupabaseErrorTranslator.setAutoDetect(true);
  /// ```
  static void setAutoDetect(bool enabled) {
    _autoDetectLanguage = enabled;
    if (enabled) {
      _currentLanguage = _detectDeviceLanguage();
    }
  }

  /// Checks if automatic language detection is enabled.
  static bool get isAutoDetectEnabled => _autoDetectLanguage;

  /// Checks if a specific language is supported.
  ///
  /// [languageCode] should be an ISO language code (e.g., 'en', 'es', 'fr').
  ///
  /// Example:
  /// ```dart
  /// final isSupported = SupabaseErrorTranslator.isLanguageSupported('es');
  /// print(isSupported); // true
  /// ```
  static bool isLanguageSupported(String languageCode) {
    return TranslationData.isLanguageSupported(languageCode);
  }

  /// Gets detailed information about the current translator state.
  ///
  /// This method is useful for debugging and understanding the current
  /// configuration of the translator.
  ///
  /// Returns a map containing:
  /// - 'currentLanguage': The current language code
  /// - 'autoDetectEnabled': Whether auto-detection is enabled
  /// - 'supportedLanguages': List of all supported language codes
  /// - 'detectedLanguage': The detected device language (if auto-detect is enabled)
  static Map<String, dynamic> getTranslatorInfo() {
    return {
      'currentLanguage': getCurrentLanguage().code,
      'autoDetectEnabled': _autoDetectLanguage,
      'supportedLanguages': getSupportedLanguages(),
      'detectedLanguage': _autoDetectLanguage ? _detectDeviceLanguage().code : null,
    };
  }
}
