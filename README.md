<<<<<<< HEAD
# Supabase Error Translator Flutter

[![pub package](https://img.shields.io/pub/v/supabase_error_translator_flutter.svg)](https://pub.dev/packages/supabase_error_translator_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)

🌍 **Make your Flutter app globally accessible!** Translate Supabase error messages into 9 languages with zero configuration. Perfect for international apps that need user-friendly error messages.

## ✨ Why Use This Package?

- 🚀 **Instant Setup**: Works out of the box with any Flutter app
- 🌐 **9 Languages**: English, Spanish, French, German, Italian, Portuguese, Dutch, Polish, Russian
- 🎯 **Complete Coverage**: All Supabase services (Auth, Database, Storage, Realtime, Functions)
- � **Smart Detection**: Automatically detects user's device language
- 🔄 **Never Fails**: Robust fallback system ensures users always get meaningful messages
- 🧪 **Battle Tested**: 100% test coverage with 31 comprehensive tests
- 📖 **Well Documented**: Clear examples and API documentation

## 🚀 Quick Start

Add to your `pubspec.yaml`:

```yaml
dependencies:
  supabase_error_translator_flutter: ^1.0.0
```

Use in your app:

```dart
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

// Set language once (auto-detects device language by default)
SupabaseErrorTranslator.setLanguage(SupportedLanguage.spanish);

// Translate any Supabase error
String friendlyMessage = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
);
// Returns: "Credenciales inválidas" (in Spanish)
```

## 🌍 Supported Languages

| Language | Code | Native Name | Status |
|----------|------|-------------|--------|
| English | `en` | English | ✅ Complete |
| Spanish | `es` | Español | ✅ Complete |
| French | `fr` | Français | ✅ Complete |
| German | `de` | Deutsch | ✅ Complete |
| Italian | `it` | Italiano | ✅ Complete |
| Portuguese | `pt` | Português | ✅ Complete |
| Dutch | `nl` | Nederlands | ✅ Complete |
| Polish | `pl` | Polski | ✅ Complete |
| Russian | `ru` | Русский | ✅ Complete |

## 🎯 Supabase Service Coverage

### 🔐 Authentication (`ErrorService.auth`)
- Login/signup errors (`invalid_credentials`, `email_not_confirmed`)
- User management (`user_not_found`, `email_exists`)
- Password policies (`password_too_weak`, `password_too_short`)
- Rate limiting (`too_many_requests`, `email_rate_limit_exceeded`)
- MFA and security (`mfa_challenge_expired`, `invalid_otp_token`)

### 🗄️ Database (`ErrorService.database`)
- Connection issues (`connection_error`, `server_disconnected`)
- Query problems (`query_failed`, `table_not_found`)
- Constraint violations (`unique_constraint_violation`, `foreign_key_violation`)
- Permission errors (`access_denied`, `invalid_authorization`)

### 📁 Storage (`ErrorService.storage`)
- File operations (`file_not_found`, `upload_failed`)
- Bucket management (`bucket_not_found`, `bucket_already_exists`)
- Authorization (`access_denied`, `invalid_token`)
- Size limits (`file_size_exceeded`, `storage_quota_exceeded`)

### 🔄 Realtime (`ErrorService.realtime`)
- Connection issues (`connection_failed`, `websocket_error`)
- Subscription errors (`subscription_error`, `channel_error`)
- Rate limiting (`connection_limit_exceeded`, `channel_limit_exceeded`)

### ⚡ Functions (`ErrorService.functions`)
- Execution errors (`function_not_found`, `execution_error`)
- Timeout issues (`timeout_error`, `memory_limit_exceeded`)
- Network problems (`network_error`, `internal_error`)

## 💡 Usage Examples

### 🎨 Basic Translation

```dart
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

// Set language once in your app
SupabaseErrorTranslator.setLanguage(SupportedLanguage.french);

// Translate any error
String message = SupabaseErrorTranslator.translate(
  'email_not_confirmed',
  ErrorService.auth,
);
print(message); // "Adresse e-mail non confirmée"
```

### 🤖 Auto-Detection

```dart
// Enable auto-detection to use device language
SupabaseErrorTranslator.setAutoDetection(true);

// Or use 'auto' for specific translations
String message = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
  language: 'auto', // Uses device language
);
```

### 🎯 Real-World Integration

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

class AuthService {
  Future<String?> signIn(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return null; // Success
      }
      
      return SupabaseErrorTranslator.translate(
        'unknown_error',
        ErrorService.auth,
      );
    } on AuthException catch (error) {
      // Automatically translate Supabase errors
      return SupabaseErrorTranslator.translate(
        error.code,
        ErrorService.auth,
      );
    } catch (error) {
      // Handle any other errors
      return SupabaseErrorTranslator.translate(
        'unknown_error',
        ErrorService.auth,
      );
    }
  }
}
```

### 🖼️ Flutter Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

class ErrorDisplay extends StatelessWidget {
  final String? errorCode;
  final ErrorService service;

  const ErrorDisplay({
    Key? key,
    this.errorCode,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorCode == null) return SizedBox.shrink();
    
    final message = SupabaseErrorTranslator.translate(errorCode!, service);
    
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade700),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🔧 Advanced Features

### 🎭 Language Override

```dart
// Translate to specific language without changing global setting
String spanishMessage = SupabaseErrorTranslator.translate(
  'user_not_found',
  ErrorService.auth,
  language: SupportedLanguage.spanish,
);

// Use string codes too
String frenchMessage = SupabaseErrorTranslator.translate(
  'connection_error',
  ErrorService.database,
  language: 'fr',
);
```

### 📊 Rich Translation Results

```dart
// Get detailed translation information
TranslationResult result = SupabaseErrorTranslator.translateErrorCode(
  'invalid_credentials',
  ErrorService.auth,
);

print(result.message);        // "Invalid credentials"
print(result.language);       // SupportedLanguage.english
print(result.originalCode);   // "invalid_credentials"
print(result.isFallback);     // false
```

### 🔍 Language Management

```dart
// Check supported languages
List<String> languages = SupabaseErrorTranslator.getSupportedLanguages();
print(languages); // ['en', 'es', 'fr', 'de', 'it', 'pt', 'nl', 'pl', 'ru']

// Check if language is supported
bool isSupported = SupabaseErrorTranslator.isLanguageSupported('es');
print(isSupported); // true

// Get current language
SupportedLanguage current = SupabaseErrorTranslator.getCurrentLanguage();
print(current); // SupportedLanguage.english
```

## 🛡️ Bulletproof Error Handling

The package uses a **4-step fallback system** to ensure users always get meaningful messages:

1. **🎯 Service-specific translation** in user's language
2. **🌍 Service-specific English** if translation missing
3. **🔄 Generic message** in user's language
4. **📝 Generic English** as final fallback

```dart
// Even with unknown error codes, users get helpful messages
String message = SupabaseErrorTranslator.translate(
  'some_unknown_error_code',
  ErrorService.auth,
);
// Returns: "An unknown error occurred" (or in user's language)
```

## 📚 Complete API Reference

### `SupabaseErrorTranslator` (Main Class)

#### Core Methods
- `translate(String? errorCode, ErrorService service, {dynamic language})` → `String`
- `translateErrorCode(String? errorCode, ErrorService service, {dynamic language})` → `TranslationResult`

#### Language Management
- `setLanguage(dynamic language, {bool autoDetect = false})` → `void`
- `getCurrentLanguage()` → `SupportedLanguage`
- `getSupportedLanguages()` → `List<String>`
- `isLanguageSupported(String languageCode)` → `bool`
- `setAutoDetection(bool enabled)` → `void`

#### Utilities
- `getTranslatorInfo()` → `Map<String, dynamic>`

### `SupportedLanguage` (Enum)

```dart
enum SupportedLanguage {
  english, spanish, french, german, italian, 
  portuguese, dutch, polish, russian
}
```

**Extensions:**
- `languageCode` → `String` (e.g., 'en', 'es')
- `displayName` → `String` (e.g., 'English', 'Español')
- `fromCode(String code)` → `SupportedLanguage?`
- `allCodes` → `List<String>`

### `ErrorService` (Enum)

```dart
enum ErrorService {
  auth, database, storage, realtime, functions
}
```

### `TranslationResult` (Class)

```dart
class TranslationResult {
  final String message;           // Translated message
  final SupportedLanguage language; // Language used
  final String originalCode;      // Original error code
  final bool isFallback;         // Whether fallback was used
}
```

## 🧪 Testing & Quality

The package includes **31 comprehensive tests** covering:

- ✅ **Language Management**: Setting, getting, and validating languages
- ✅ **Translation Accuracy**: Correct translations for all error codes
- ✅ **Fallback System**: Robust error handling with 4-step fallbacks
- ✅ **Auto-Detection**: Device language detection functionality
- ✅ **Service Coverage**: All Supabase services and error types
- ✅ **Edge Cases**: Null values, empty strings, unknown codes
- ✅ **Model Validation**: Data structures and enums
- ✅ **Exception Handling**: Proper error propagation

Run tests:

```bash
flutter test
```

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  supabase_error_translator_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🌍 Adding New Languages

1. Add the language to `SupportedLanguage` enum
2. Add translations to `TranslationData` class
3. Update extension methods for language codes
4. Add comprehensive tests
5. Update documentation

### 🔧 Adding New Error Codes

1. Add error code to appropriate service section
2. Provide translations for all 9 languages
3. Add test cases for the new error code
4. Update documentation

### 🐛 Reporting Issues

Please use the [GitHub issue tracker](https://github.com/mrehman29/supabase_error_translator_flutter/issues) to report bugs or request features.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is an independent project and is **NOT officially associated** with Supabase. It's created by the community for the community.

## 🚀 Roadmap

- [ ] Add more languages (Japanese, Korean, Chinese)
- [ ] Support for custom error codes
- [ ] Integration with Flutter's `Localizations`
- [ ] Contextual error messages
- [ ] Error analytics and reporting
- [ ] VS Code extension for managing translations

## 📞 Support

- 📖 **Documentation**: Check the API reference above
- 💬 **Issues**: [GitHub Issues](https://github.com/mrehman29/supabase_error_translator_flutter/issues)
- 📧 **Email**: contact@mrehman.co.uk
- 💻 **Examples**: Check the `/example` folder

## 🙏 Acknowledgments

- Thanks to the Flutter and Supabase communities
- All contributors who helped with translations
- Beta testers who provided feedback

---

**Made with ❤️ for the Flutter community**

*Give us a ⭐ if this package helped you build better apps!*
=======
# supabase_error_translator_flutter
Translate Supabase error codes into user-friendly messages
>>>>>>> a9c98b20e4f5802d741c1f1fd5e8645656686d4d
