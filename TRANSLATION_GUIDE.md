# Translation Guide for Supabase Error Translator Flutter

Welcome to the comprehensive guide for managing translations in the Supabase Error Translator Flutter package! This guide will help you understand, maintain, and extend the translation system.

## 📋 Table of Contents

1. [Understanding the System](#understanding-the-system)
2. [Adding New Languages](#adding-new-languages)
3. [Adding New Error Codes](#adding-new-error-codes)
4. [Translation Quality Guidelines](#translation-quality-guidelines)
5. [Testing Your Changes](#testing-your-changes)
6. [Common Patterns](#common-patterns)
7. [Maintenance](#maintenance)

## 🧠 Understanding the System

### Translation Architecture

The translation system uses a hierarchical structure:

```
Translation Data
├── Language Code (e.g., 'en', 'es', 'fr')
│   ├── unknown_error: "Generic fallback message"
│   └── services:
│       ├── auth: { error_code: "Translation", ... }
│       ├── database: { error_code: "Translation", ... }
│       ├── storage: { error_code: "Translation", ... }
│       ├── realtime: { error_code: "Translation", ... }
│       └── functions: { error_code: "Translation", ... }
```

### 4-Step Fallback Chain

When an error code is not found, the system follows this fallback order:

1. **Service-specific + User Language**: `[language] → services → [service] → [error_code]`
2. **Service-specific + English**: `en → services → [service] → [error_code]`
3. **Generic + User Language**: `[language] → unknown_error`
4. **Generic + English**: `en → unknown_error`

This ensures users always get a meaningful message, even for unknown error codes.

## 🌍 Adding New Languages

### Step 1: Update the Language Enum

Add your language to the `SupportedLanguage` enum in `lib/src/models/supported_language.dart`:

```dart
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
  
  /// Italian (Italiano) - NEW LANGUAGE
  it,
  
  // ... existing languages
}
```

### Step 2: Update Extension Methods

Add support for your language in the extension methods:

```dart
extension SupportedLanguageExtension on SupportedLanguage {
  /// Returns the language code (e.g., 'en', 'es', 'fr')
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
      case SupportedLanguage.it:  // NEW
        return 'it';
      // ... other cases
    }
  }
  
  /// Returns the display name in the native language
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
      case SupportedLanguage.it:  // NEW
        return 'Italiano';
      // ... other cases
    }
  }
  
  /// Creates a SupportedLanguage from a language code
  static SupportedLanguage? fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return SupportedLanguage.en;
      case 'de':
        return SupportedLanguage.de;
      case 'es':
        return SupportedLanguage.es;
      case 'fr':
        return SupportedLanguage.fr;
      case 'it':  // NEW
        return SupportedLanguage.it;
      // ... other cases
      default:
        return null;
    }
  }
}
```

### Step 3: Create Translation File

Create a new file `lib/src/data/translations/it.dart` (replace 'it' with your language code):

```dart
/// Italian translations for Supabase error codes
const Map<String, dynamic> italianTranslations = {
  'unknown_error': 'Si è verificato un errore sconosciuto',
  'services': {
    'auth': {
      'email_not_confirmed': 'Email non confermata',
      'invalid_credentials': 'Credenziali di accesso non valide',
      'user_not_found': 'Utente non trovato',
      'user_already_exists': 'L\'utente esiste già',
      'password_too_short': 'Password troppo corta',
      'password_too_weak': 'Password troppo debole',
      'email_already_registered': 'Email già registrata',
      'phone_already_registered': 'Numero di telefono già registrato',
      'invalid_phone': 'Numero di telefono non valido',
      'invalid_email': 'Indirizzo email non valido',
      'signup_disabled': 'Registrazione disabilitata',
      'email_rate_limit_exceeded': 'Limite di invio email superato',
      'sms_rate_limit_exceeded': 'Limite di invio SMS superato',
      'too_many_requests': 'Troppe richieste',
      'phone_exists': 'Il numero di telefono esiste già',
      'email_exists': 'L\'email esiste già',
      'session_expired': 'Sessione scaduta',
      'token_expired': 'Token scaduto',
      'invalid_token': 'Token non valido',
      'mfa_challenge_expired': 'Sfida MFA scaduta',
      'mfa_verification_failed': 'Verifica MFA fallita',
      'provider_disabled': 'Provider disabilitato',
      'oauth_callback_error': 'Errore callback OAuth',
      'otp_expired': 'Il token è scaduto o non valido',
      'over_email_send_rate_limit': 'Puoi richiedere solo una volta al minuto',
      // ... add all other auth error codes
    },
    'database': {
      'connection_failed': 'Connessione al database fallita',
      'query_timeout': 'Timeout della query',
      'duplicate_key': 'Violazione chiave duplicata',
      'foreign_key_violation': 'Violazione chiave esterna',
      'not_null_violation': 'Violazione NOT NULL',
      'check_violation': 'Violazione vincolo CHECK',
      'unique_violation': 'Violazione vincolo UNIQUE',
      'permission_denied': 'Permesso negato',
      'invalid_input': 'Input non valido',
      'syntax_error': 'Errore di sintassi SQL',
      'type_mismatch': 'Tipo di dati non corrispondente',
      'out_of_range': 'Valore fuori intervallo',
      'deadlock_detected': 'Deadlock rilevato',
      'serialization_failure': 'Errore di serializzazione',
      'connection_limit_exceeded': 'Limite connessioni superato',
      'disk_full': 'Spazio su disco esaurito',
      'memory_exhausted': 'Memoria esaurita',
      'table_not_found': 'Tabella non trovata',
      'column_not_found': 'Colonna non trovata',
      'function_not_found': 'Funzione non trovata',
    },
    'storage': {
      'bucket_not_found': 'Bucket non trovato',
      'file_not_found': 'File non trovato',
      'bucket_already_exists': 'Il bucket esiste già',
      'file_already_exists': 'Il file esiste già',
      'file_size_limit_exceeded': 'Limite dimensione file superato',
      'invalid_file_type': 'Tipo di file non valido',
      'permission_denied': 'Accesso allo storage negato',
      'invalid_token': 'Token storage non valido',
      'upload_failed': 'Caricamento file fallito',
      'download_failed': 'Download file fallito',
      'delete_failed': 'Eliminazione file fallita',
      'quota_exceeded': 'Quota storage superata',
      'invalid_path': 'Percorso file non valido',
      'operation_not_supported': 'Operazione non supportata',
      'bucket_not_empty': 'Il bucket non è vuoto',
      'invalid_bucket_name': 'Nome bucket non valido',
      'file_corrupted': 'File corrotto',
      'network_error': 'Errore di rete',
      'service_unavailable': 'Servizio storage non disponibile',
      // ... add all other storage error codes
    },
    'realtime': {
      'connection_failed': 'Connessione realtime fallita',
      'channel_not_found': 'Canale non trovato',
      'subscription_failed': 'Sottoscrizione fallita',
      'unauthorized': 'Accesso realtime non autorizzato',
      'rate_limit_exceeded': 'Limite di velocità superato',
      'channel_limit_exceeded': 'Limite canali superato',
      'connection_limit_exceeded': 'Limite connessioni superato',
      'invalid_channel_name': 'Nome canale non valido',
      'tenant_not_found': 'Tenant non trovato',
      'realtime_disabled': 'Realtime disabilitato',
      'websocket_error': 'Errore WebSocket',
      'message_too_large': 'Messaggio troppo grande',
      'invalid_message_format': 'Formato messaggio non valido',
      'join_rate_limit': 'Limite velocità join superato',
      'broadcast_failed': 'Broadcast fallito',
      'presence_failed': 'Aggiornamento presence fallito',
      'node_disconnected': 'Nodo disconnesso',
      'migration_failed': 'Migrazione fallita',
      'counter_tracking_error': 'Errore tracking contatore',
      // ... add all other realtime error codes
    },
    'functions': {
      'function_not_found': 'Funzione non trovata',
      'execution_failed': 'Esecuzione funzione fallita',
      'timeout': 'Timeout esecuzione funzione',
      'memory_limit_exceeded': 'Limite memoria superato',
      'invalid_input': 'Input funzione non valido',
      'permission_denied': 'Permesso esecuzione funzione negato',
      'rate_limit_exceeded': 'Limite velocità funzione superato',
      'cold_start_timeout': 'Timeout cold start',
      'network_error': 'Errore di rete nella funzione',
      'internal_error': 'Errore interno funzione',
    },
  },
};
```

### Step 4: Update Translation Data

Add your translation to the main translation data in `lib/src/data/translation_data.dart`:

```dart
import 'translations/it.dart';

class TranslationData {
  static const Map<String, Map<String, dynamic>> _translations = {
    'en': englishTranslations,
    'de': germanTranslations,
    'es': spanishTranslations,
    'fr': frenchTranslations,
    'it': italianTranslations,  // NEW
    // ... other languages
  };
}
```

### Step 5: Write Comprehensive Tests

Add tests for your new language in `test/supabase_error_translator_flutter_test.dart`:

```dart
group('Italian Language Tests', () {
  test('should translate to Italian', () {
    SupabaseErrorTranslator.setLanguage(SupportedLanguage.it);
    
    final result = SupabaseErrorTranslator.translateErrorCode(
      'email_not_confirmed',
      ErrorService.auth,
    );
    
    expect(result.message, 'Email non confermata');
    expect(result.language, SupportedLanguage.it);
    expect(result.originalCode, 'email_not_confirmed');
    expect(result.isFallback, false);
  });
  
  test('should handle unknown error in Italian', () {
    SupabaseErrorTranslator.setLanguage(SupportedLanguage.it);
    
    final result = SupabaseErrorTranslator.translateErrorCode(
      'unknown_error_code',
      ErrorService.auth,
    );
    
    expect(result.message, 'Si è verificato un errore sconosciuto');
    expect(result.language, SupportedLanguage.it);
    expect(result.isFallback, true);
  });
  
  test('should translate from Italian language code', () {
    SupabaseErrorTranslator.setLanguage('it');
    
    final message = SupabaseErrorTranslator.translate(
      'invalid_credentials',
      ErrorService.auth,
    );
    
    expect(message, 'Credenziali di accesso non valide');
  });
});
```

### Step 6: Update Documentation

1. **Update README.md**: Add the new language to the supported languages table
2. **Update CHANGELOG.md**: Document the new language addition
3. **Update example app**: The new language will automatically appear in the dropdown

## 🔧 Adding New Error Codes

### Step 1: Identify the Service

Determine which Supabase service the error belongs to:
- **Auth**: Authentication, user management, sessions
- **Database**: SQL queries, connections, constraints
- **Storage**: File operations, buckets, permissions
- **Realtime**: WebSocket connections, channels, subscriptions
- **Functions**: Edge function execution, timeouts, memory

### Step 2: Choose Error Code Name

Follow these naming conventions:
- Use `snake_case` format
- Be descriptive but concise
- Use consistent patterns within services
- Examples: `connection_failed`, `file_not_found`, `rate_limit_exceeded`

### Step 3: Add to All Language Files

Add the error code to **every** language file in `lib/src/data/translations/`:

```dart
// In en.dart
'auth': {
  // ... existing codes
  'new_auth_error': 'New authentication error occurred',
},

// In es.dart
'auth': {
  // ... existing codes
  'new_auth_error': 'Se produjo un nuevo error de autenticación',
},

// In fr.dart
'auth': {
  // ... existing codes
  'new_auth_error': 'Une nouvelle erreur d\'authentification s\'est produite',
},

// ... repeat for all languages
```

### Step 4: Write Tests

Add comprehensive tests for the new error code:

```dart
group('New Error Code Tests', () {
  test('should translate new error code in all languages', () {
    for (final language in SupportedLanguage.values) {
      SupabaseErrorTranslator.setLanguage(language);
      
      final result = SupabaseErrorTranslator.translateErrorCode(
        'new_auth_error',
        ErrorService.auth,
      );
      
      expect(result.message, isNotEmpty);
      expect(result.language, language);
      expect(result.originalCode, 'new_auth_error');
      expect(result.isFallback, false);
    }
  });
});
```

### Step 5: Update Documentation

1. **Add to README.md**: Include in the appropriate service section
2. **Update CHANGELOG.md**: Document the new error code
3. **Update example app**: Add to the relevant service error list

## 🎯 Translation Quality Guidelines

### Accuracy
- **Use native speakers** when possible
- **Research context**: Understand what the error means in Supabase
- **Check existing translations**: Maintain consistency with similar errors
- **Verify technical terms**: Ensure technical terms are correctly translated

### Clarity
- **User-friendly language**: Avoid overly technical jargon
- **Be specific**: Help users understand what went wrong
- **Actionable when possible**: Suggest what the user might do
- **Consistent tone**: Maintain the same tone across all translations

### Cultural Appropriateness
- **Formal vs. informal**: Choose appropriate formality level
- **Regional variations**: Consider different dialects/regions
- **Cultural context**: Ensure messages are culturally appropriate
- **Length considerations**: Some languages are more verbose

### Technical Considerations
- **Character limits**: Consider UI space constraints
- **Special characters**: Ensure proper encoding
- **RTL languages**: Consider right-to-left reading languages
- **Pluralization**: Handle singular/plural forms correctly

## 🧪 Testing Your Changes

### Unit Tests
Always write comprehensive unit tests:

```dart
test('should handle [specific scenario]', () {
  // Setup
  SupabaseErrorTranslator.setLanguage(SupportedLanguage.yourLanguage);
  
  // Execute
  final result = SupabaseErrorTranslator.translateErrorCode(
    'error_code',
    ErrorService.auth,
  );
  
  // Verify
  expect(result.message, 'Expected translation');
  expect(result.language, SupportedLanguage.yourLanguage);
  expect(result.isFallback, false);
});
```

### Manual Testing
Use the example app to test:
1. **Language switching**: Verify translations appear correctly
2. **Service testing**: Test error codes in different services
3. **Fallback testing**: Test with unknown error codes
4. **Edge cases**: Test with empty strings, special characters

### Performance Testing
- **Memory usage**: Check that translations don't cause memory leaks
- **Lookup speed**: Ensure translation lookups are fast
- **App startup**: Verify translations don't slow app startup

## 📋 Common Patterns

### Error Code Patterns by Service

#### Authentication Service
- `*_not_found`: User, session, or resource not found
- `*_already_exists`: User, email, or phone already exists
- `*_expired`: Session, token, or challenge expired
- `*_invalid`: Invalid credentials, token, or format
- `*_disabled`: Feature or provider disabled
- `*_rate_limit_exceeded`: Rate limiting errors
- `*_failed`: General failure errors

#### Database Service
- `*_failed`: Connection, query, or operation failed
- `*_violation`: Constraint violations
- `*_not_found`: Table, column, or function not found
- `*_exceeded`: Limits exceeded
- `*_error`: Syntax, type, or general errors

#### Storage Service
- `*_not_found`: Bucket or file not found
- `*_already_exists`: Bucket or file already exists
- `*_failed`: Upload, download, or delete failed
- `*_exceeded`: Size or quota limits exceeded
- `*_invalid`: Invalid path, token, or file type

#### Realtime Service
- `*_failed`: Connection, subscription, or operation failed
- `*_not_found`: Channel or tenant not found
- `*_exceeded`: Rate or connection limits exceeded
- `*_invalid`: Invalid channel name or message format
- `*_disabled`: Realtime disabled
- `*_error`: WebSocket or tracking errors

#### Functions Service
- `*_not_found`: Function not found
- `*_failed`: Execution failed
- `*_exceeded`: Memory or rate limits exceeded
- `*_timeout`: Execution or cold start timeout
- `*_error`: Network or internal errors

## 🔄 Maintenance

### Regular Updates
- **Monitor Supabase releases**: Watch for new error codes
- **Community feedback**: Listen to user reports about translations
- **Review accuracy**: Regularly review translations for accuracy
- **Update dependencies**: Keep Flutter/Dart dependencies current

### Quality Assurance
- **Native speaker reviews**: Have native speakers review translations
- **User testing**: Test with real users when possible
- **A/B testing**: Test different translations for effectiveness
- **Analytics**: Monitor which error codes are most common

### Documentation
- **Keep guides updated**: Update this guide when structure changes
- **Example maintenance**: Keep example app current
- **API documentation**: Update code documentation
- **README updates**: Keep README.md current

### Performance Monitoring
- **Memory usage**: Monitor for memory leaks
- **Lookup performance**: Ensure translations remain fast
- **App size**: Monitor impact on app size
- **Build times**: Ensure translations don't slow builds

## 🤝 Contributing

### Getting Started
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write comprehensive tests
5. Update documentation
6. Submit a pull request

### Code Review
- Follow the existing code style
- Ensure all tests pass
- Update documentation
- Get native speaker approval for translations

### Community
- Join discussions about translations
- Help review other contributors' work
- Share knowledge about localization
- Report bugs and suggest improvements

---

## 📞 Need Help?

- **GitHub Issues**: Report bugs or request features
- **Email**: contact@mrehman.co.uk
- **Documentation**: Check the main README
- **Example App**: Use the example for testing

Thank you for helping make Supabase more accessible to users worldwide! 🌍
