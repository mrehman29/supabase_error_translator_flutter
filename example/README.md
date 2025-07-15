# Supabase Error Translator Flutter - Example App

This interactive example app demonstrates all the features of the Supabase Error Translator Flutter package in a user-friendly way.

## 🎯 What You'll Learn

- **Quick Translation**: See how to translate Supabase error codes instantly
- **Language Support**: Switch between 9 supported languages in real-time
- **Service Coverage**: Explore error codes from all 5 Supabase services
- **Auto-Detection**: Experience automatic device language detection
- **Testing Tools**: Test custom error codes and edge cases
- **Rich Results**: View detailed translation information and metadata

## 🚀 Getting Started

1. **Navigate to the example directory**:
   ```bash
   cd example
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📱 App Features

### 🔄 Translator Tab
The main translation interface where you can:
- **Toggle Auto-Detection**: Enable/disable automatic device language detection
- **Select Language**: Choose from 9 supported languages manually
- **Pick Service**: Select from Auth, Database, Storage, Realtime, or Functions
- **Choose Error Code**: Browse real Supabase error codes for each service
- **View Results**: See translations with metadata (language, fallback status)
- **Copy Translations**: One-click copy to clipboard

### 🧪 Testing Tab
Advanced testing features for developers:
- **Custom Error Codes**: Test your own error codes
- **Unknown Error Testing**: See how the fallback system works
- **All Languages Test**: View the same error in all 9 languages
- **Edge Cases**: Test null values and error handling

### ℹ️ Info Tab
Package information and current settings:
- **Supported Languages**: Complete list with native names
- **Service Coverage**: Error count per service
- **Current Settings**: View active language and configuration

## 🌐 Language Testing

The app includes comprehensive language testing features:

### Supported Languages
- 🇺🇸 **English** (en) - Base language
- 🇪🇸 **Spanish** (es) - Español
- 🇫🇷 **French** (fr) - Français
- 🇩🇪 **German** (de) - Deutsch
- 🇵🇹 **Portuguese** (pt) - Português
- 🇵🇱 **Polish** (pl) - Polski
- 🇯🇵 **Japanese** (jp) - 日本語
- 🇰🇷 **Korean** (kr) - 한국어
- 🇨🇳 **Chinese** (cn) - 中文

### Auto-Detection
The app demonstrates automatic language detection:
- Detects your device's language setting
- Falls back to English if device language isn't supported
- Shows current language in the UI

## 🔧 Service Coverage

### 🔐 Authentication (18 error codes)
Common auth errors like:
- `email_not_confirmed`
- `invalid_credentials`
- `user_not_found`
- `password_too_weak`
- `session_expired`

### 🗄️ Database (12 error codes)
Database operation errors:
- `connection_failed`
- `query_timeout`
- `duplicate_key`
- `foreign_key_violation`
- `permission_denied`

### 📁 Storage (12 error codes)
File and storage errors:
- `bucket_not_found`
- `file_not_found`
- `upload_failed`
- `quota_exceeded`
- `invalid_file_type`

### 🔄 Realtime (11 error codes)
Real-time connection errors:
- `connection_failed`
- `channel_not_found`
- `subscription_failed`
- `rate_limit_exceeded`
- `websocket_error`

### ⚡ Functions (10 error codes)
Edge function errors:
- `function_not_found`
- `execution_failed`
- `timeout`
- `memory_limit_exceeded`
- `network_error`

## 🎨 UI Features

### Modern Design
- Material 3 design system
- Responsive layout
- Card-based UI
- Intuitive navigation

### Interactive Elements
- Dropdown selections
- Switch toggles
- Copy-to-clipboard buttons
- Modal dialogs for detailed info

### Visual Feedback
- Color-coded results (green for success, orange for fallback)
- Loading states
- Success/error messages
- Helpful icons

## 🧭 How to Use

1. **Start with the Translator tab** to see basic functionality
2. **Try different languages** to see translations change
3. **Switch services** to explore different error types
4. **Test auto-detection** by toggling the switch
5. **Use the Testing tab** for advanced scenarios
6. **Check the Info tab** for package details

## 💡 Real-World Integration

This example shows how to integrate the package in your Flutter app:

```dart
// Basic usage
String message = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
);

// Rich result with metadata
TranslationResult result = SupabaseErrorTranslator.translateErrorCode(
  'invalid_credentials',
  ErrorService.auth,
);

// Auto-detect language
SupabaseErrorTranslator.setLanguage(null, autoDetect: true);

// Manual language setting
SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);
```

## 🔍 Testing Features

### Custom Error Codes
Test your own error codes to see how the fallback system works:
- Enter any error code
- See if it has a translation
- View fallback behavior

### Edge Cases
Test edge cases like:
- Empty strings
- Very long error codes
- Special characters
- Null values

### Performance Testing
- Test with many rapid language changes
- Try large error code lists
- Monitor memory usage

## 📚 Learning Resources

This example teaches you:
- How to set up the package
- Best practices for error handling
- Language management strategies
- Testing methodologies
- UI integration patterns

## 🎯 Next Steps

After exploring the example:
1. Install the package in your project
2. Implement error translation in your Supabase error handling
3. Choose appropriate languages for your user base
4. Test with real error scenarios
5. Customize messages if needed

## 🔗 Useful Links

- **Package Documentation**: Check the main README
- **API Reference**: View code documentation
- **Translation Guide**: Learn how to add languages
- **GitHub Issues**: Report bugs or request features

---

**Happy translating! 🌍**

## Code Examples

The example includes practical implementations of:

```dart
// Basic translation
String message = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
);

// Auto-detection
SupabaseErrorTranslator.setAutoDetection(true);

// Language override
String spanishMessage = SupabaseErrorTranslator.translate(
  'user_not_found',
  ErrorService.auth,
  language: SupportedLanguage.spanish,
);

// Rich translation results
TranslationResult result = SupabaseErrorTranslator.translateErrorCode(
  'email_not_confirmed',
  ErrorService.auth,
);
```

## UI Components

The example shows how to build user-friendly error displays and language selection interfaces that integrate seamlessly with the package.

## Testing Different Scenarios

Use the example to test:
- ✅ All supported languages
- ✅ All error services
- ✅ Known and unknown error codes
- ✅ Auto-detection functionality
- ✅ Fallback behavior
- ✅ Real-time language switching
