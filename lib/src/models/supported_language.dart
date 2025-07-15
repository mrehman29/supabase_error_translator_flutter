/// Enum representing the supported languages for error translation.
enum SupportedLanguage {
  /// English
  en,

  /// German (Deutsch)
  de,

  /// Spanish (Español)
  es,

  /// French (Français)
  fr,

  /// Japanese (日本語)
  jp,

  /// Korean (한국어)
  kr,

  /// Polish (Polski)
  pl,

  /// Portuguese (Português)
  pt,

  /// Chinese (中文)
  cn,
}

/// Extension methods for [SupportedLanguage] enum.
extension SupportedLanguageExtension on SupportedLanguage {
  /// Returns the ISO language code.
  String get code {
    switch (this) {
      case SupportedLanguage.en:
        return 'en';
      case SupportedLanguage.de:
        return 'de';
      case SupportedLanguage.es:
        return 'es';
      case SupportedLanguage.fr:
        return 'fr';
      case SupportedLanguage.jp:
        return 'jp';
      case SupportedLanguage.kr:
        return 'kr';
      case SupportedLanguage.pl:
        return 'pl';
      case SupportedLanguage.pt:
        return 'pt';
      case SupportedLanguage.cn:
        return 'cn';
    }
  }

  /// Returns the display name of the language.
  String get displayName {
    switch (this) {
      case SupportedLanguage.en:
        return 'English';
      case SupportedLanguage.de:
        return 'Deutsch';
      case SupportedLanguage.es:
        return 'Español';
      case SupportedLanguage.fr:
        return 'Français';
      case SupportedLanguage.jp:
        return '日本語';
      case SupportedLanguage.kr:
        return '한국어';
      case SupportedLanguage.pl:
        return 'Polski';
      case SupportedLanguage.pt:
        return 'Português';
      case SupportedLanguage.cn:
        return '中文';
    }
  }

  /// Creates a [SupportedLanguage] from a language code.
  static SupportedLanguage fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return SupportedLanguage.en;
      case 'de':
        return SupportedLanguage.de;
      case 'es':
        return SupportedLanguage.es;
      case 'fr':
        return SupportedLanguage.fr;
      case 'jp':
        return SupportedLanguage.jp;
      case 'kr':
        return SupportedLanguage.kr;
      case 'pl':
        return SupportedLanguage.pl;
      case 'pt':
        return SupportedLanguage.pt;
      case 'cn':
        return SupportedLanguage.cn;
      default:
        return SupportedLanguage.en; // Default to English
    }
  }

  /// Returns all supported language codes.
  static List<String> get allCodes {
    return SupportedLanguage.values.map((lang) => lang.code).toList();
  }
}
