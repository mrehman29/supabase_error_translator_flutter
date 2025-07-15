import 'package:flutter/foundation.dart';

import 'package:supabase_error_translator_flutter/src/models/supported_language.dart';

/// Represents the result of a translation operation.
@immutable
class TranslationResult {
  /// Creates a new [TranslationResult].
  const TranslationResult({
    required this.message,
    required this.language,
    this.originalCode,
    this.isFallback = false,
  });

  /// Creates a fallback translation result.
  factory TranslationResult.fallback({
    required String message,
    required SupportedLanguage language,
    String? originalCode,
  }) {
    return TranslationResult(
      message: message,
      language: language,
      originalCode: originalCode,
      isFallback: true,
    );
  }

  /// The translated error message.
  final String message;

  /// The language used for the translation.
  final SupportedLanguage language;

  /// The original error code that was translated.
  final String? originalCode;

  /// Whether the translation was successful or fell back to a default.
  final bool isFallback;

  @override
  String toString() {
    return 'TranslationResult(message: $message, language: ${language.code}, '
        'originalCode: $originalCode, isFallback: $isFallback)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TranslationResult &&
        other.message == message &&
        other.language == language &&
        other.originalCode == originalCode &&
        other.isFallback == isFallback;
  }

  @override
  int get hashCode {
    return message.hashCode ^ language.hashCode ^ originalCode.hashCode ^ isFallback.hashCode;
  }
}
