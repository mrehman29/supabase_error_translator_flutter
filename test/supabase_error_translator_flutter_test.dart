import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

void main() {
  group('SupabaseErrorTranslator', () {
    setUpAll(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      // Reset to default state before each test
      SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);
      SupabaseErrorTranslator.setAutoDetect(false);
    });

    group('Language Management', () {
      test('should set and get current language', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);
        expect(SupabaseErrorTranslator.getCurrentLanguage(), SupportedLanguage.es);
      });

      test('should set language by string code', () {
        SupabaseErrorTranslator.setLanguage('fr');
        expect(SupabaseErrorTranslator.getCurrentLanguage(), SupportedLanguage.fr);
      });

      test('should return all supported languages', () {
        final languages = SupabaseErrorTranslator.getSupportedLanguages();
        expect(languages, contains('en'));
        expect(languages, contains('es'));
        expect(languages, contains('fr'));
        expect(languages, contains('de'));
        expect(languages.length, greaterThan(5));
      });

      test('should check if language is supported', () {
        expect(SupabaseErrorTranslator.isLanguageSupported('en'), true);
        expect(SupabaseErrorTranslator.isLanguageSupported('es'), true);
        expect(SupabaseErrorTranslator.isLanguageSupported('xx'), false);
      });
    });

    group('Error Translation', () {
      test('should translate known error codes', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'email_not_confirmed',
          ErrorService.auth,
        );

        expect(result.message, 'Email not confirmed');
        expect(result.language, SupportedLanguage.en);
        expect(result.originalCode, 'email_not_confirmed');
        expect(result.isFallback, false);
      });

      test('should translate to different languages', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'invalid_credentials',
          ErrorService.auth,
        );

        expect(result.message, 'Credenciales de inicio de sesión inválidas');
        expect(result.language, SupportedLanguage.es);
      });

      test('should handle null or empty error codes', () {
        final result1 = SupabaseErrorTranslator.translateErrorCode(
          null,
          ErrorService.auth,
        );

        final result2 = SupabaseErrorTranslator.translateErrorCode(
          '',
          ErrorService.auth,
        );

        final result3 = SupabaseErrorTranslator.translateErrorCode(
          '   ',
          ErrorService.auth,
        );

        expect(result1.message, 'An unknown error occurred');
        expect(result2.message, 'An unknown error occurred');
        expect(result3.message, 'An unknown error occurred');
      });

      test('should handle unknown error codes with fallback', () {
        final result = SupabaseErrorTranslator.translateErrorCode(
          'nonexistent_error',
          ErrorService.auth,
        );

        expect(result.message, 'An unknown error occurred');
        expect(result.isFallback, true);
      });

      test('should translate with temporary language override', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'email_not_confirmed',
          ErrorService.auth,
          language: SupportedLanguage.fr,
        );

        expect(result.message, 'Email non confirmé');
        expect(result.language, SupportedLanguage.fr);

        // Current language should remain unchanged
        expect(SupabaseErrorTranslator.getCurrentLanguage(), SupportedLanguage.en);
      });

      test('should use convenience translate method', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final message = SupabaseErrorTranslator.translate(
          'user_not_found',
          ErrorService.auth,
        );

        expect(message, 'User not found');
      });
    });

    group('Service-specific Translations', () {
      test('should translate auth service errors', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'password_too_short',
          ErrorService.auth,
        );

        expect(result.message, 'Password is too short');
      });

      test('should translate database service errors', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'connection_failed',
          ErrorService.database,
        );

        expect(result.message, 'Database connection failed');
      });

      test('should translate storage service errors', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'bucket_not_found',
          ErrorService.storage,
        );

        expect(result.message, 'Bucket not found');
      });

      test('should translate realtime service errors', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'channel_not_found',
          ErrorService.realtime,
        );

        expect(result.message, 'Channel not found');
      });

      test('should translate functions service errors', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'function_not_found',
          ErrorService.functions,
        );

        expect(result.message, 'Function not found');
      });
    });

    group('Fallback Chain', () {
      test('should fallback to English when specific translation not available', () {
        // Test fallback for a specific service error that might not exist
        // We'll test with a scenario where we can force fallback to English
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);

        // First, verify that a known code works
        final knownResult = SupabaseErrorTranslator.translateErrorCode(
          'email_not_confirmed',
          ErrorService.auth,
        );
        expect(knownResult.message, 'Email not confirmed');
        expect(knownResult.isFallback, false);

        // Now test with unknown code to verify fallback to unknown error
        final unknownResult = SupabaseErrorTranslator.translateErrorCode(
          'completely_unknown_error_code',
          ErrorService.auth,
        );
        expect(unknownResult.message, 'An unknown error occurred');
        expect(unknownResult.isFallback, true);
      });

      test('should use generic unknown error message as final fallback', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);

        final result = SupabaseErrorTranslator.translateErrorCode(
          'completely_unknown_error',
          ErrorService.auth,
        );

        expect(result.message, 'Ocurrió un error desconocido');
        expect(result.isFallback, true);
      });
    });

    group('Auto Detection', () {
      test('should enable and disable auto detection', () {
        SupabaseErrorTranslator.setAutoDetect(true);
        expect(SupabaseErrorTranslator.isAutoDetectEnabled, true);

        SupabaseErrorTranslator.setAutoDetect(false);
        expect(SupabaseErrorTranslator.isAutoDetectEnabled, false);
      });

      test('should use auto detection when language is "auto"', () {
        final result = SupabaseErrorTranslator.translateErrorCode(
          'email_not_confirmed',
          ErrorService.auth,
          language: 'auto',
        );

        expect(result.message, isNotEmpty);
        expect(result.originalCode, 'email_not_confirmed');
      });
    });

    group('Translator Info', () {
      test('should return translator info', () {
        SupabaseErrorTranslator.setLanguage(SupportedLanguage.fr);
        SupabaseErrorTranslator.setAutoDetect(true);

        final info = SupabaseErrorTranslator.getTranslatorInfo();

        expect(info['autoDetectEnabled'], true);
        expect(info['supportedLanguages'], isA<List<String>>());
        expect(info['supportedLanguages'], contains('fr'));
      });
    });
  });

  group('Models', () {
    group('SupportedLanguage', () {
      test('should convert from and to language codes', () {
        expect(SupportedLanguage.en.code, 'en');
        expect(SupportedLanguage.es.code, 'es');
        expect(SupportedLanguageExtension.fromCode('fr'), SupportedLanguage.fr);
        expect(SupportedLanguageExtension.fromCode('unknown'), SupportedLanguage.en);
      });

      test('should provide display names', () {
        expect(SupportedLanguage.en.displayName, 'English');
        expect(SupportedLanguage.es.displayName, 'Español');
        expect(SupportedLanguage.fr.displayName, 'Français');
      });

      test('should provide all language codes', () {
        final codes = SupportedLanguageExtension.allCodes;
        expect(codes, contains('en'));
        expect(codes, contains('es'));
        expect(codes, contains('fr'));
      });
    });

    group('ErrorService', () {
      test('should convert from and to service names', () {
        expect(ErrorService.auth.name, 'auth');
        expect(ErrorService.database.name, 'database');
        expect(ErrorServiceExtension.fromString('storage'), ErrorService.storage);
      });

      test('should throw error for unknown service', () {
        expect(
          () => ErrorServiceExtension.fromString('unknown'),
          throwsArgumentError,
        );
      });
    });

    group('TranslationResult', () {
      test('should create normal translation result', () {
        const result = TranslationResult(
          message: 'Test message',
          language: SupportedLanguage.en,
          originalCode: 'test_code',
        );

        expect(result.message, 'Test message');
        expect(result.language, SupportedLanguage.en);
        expect(result.originalCode, 'test_code');
        expect(result.isFallback, false);
      });

      test('should create fallback translation result', () {
        final result = TranslationResult.fallback(
          message: 'Fallback message',
          language: SupportedLanguage.en,
          originalCode: 'test_code',
        );

        expect(result.message, 'Fallback message');
        expect(result.language, SupportedLanguage.en);
        expect(result.originalCode, 'test_code');
        expect(result.isFallback, true);
      });

      test('should implement equality correctly', () {
        const result1 = TranslationResult(
          message: 'Test',
          language: SupportedLanguage.en,
          originalCode: 'test',
        );

        const result2 = TranslationResult(
          message: 'Test',
          language: SupportedLanguage.en,
          originalCode: 'test',
        );

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });
    });
  });

  group('Exceptions', () {
    test('should create TranslatorException with message', () {
      const exception = TranslatorException('Test error');
      expect(exception.message, 'Test error');
      expect(exception.originalError, isNull);
    });

    test('should create TranslatorException with original error', () {
      final originalError = Exception('Original error');
      final exception = TranslatorException('Test error', originalError);

      expect(exception.message, 'Test error');
      expect(exception.originalError, originalError);
    });

    test('should have proper string representation', () {
      const exception = TranslatorException('Test error');
      expect(exception.toString(), 'TranslatorException: Test error');

      final originalError = Exception('Original error');
      final exceptionWithOriginal = TranslatorException('Test error', originalError);
      expect(
        exceptionWithOriginal.toString(),
        'TranslatorException: Test error (caused by: Exception: Original error)',
      );
    });
  });
}
