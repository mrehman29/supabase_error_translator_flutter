# Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview

This is a Flutter package for translating Supabase error codes and messages into multiple languages. The package provides internationalization support for Flutter apps using Supabase.

## Code Style Guidelines

### Dart/Flutter Standards
- Follow official Dart and Flutter style guides
- Use single quotes for strings
- Add trailing commas for better diffs
- Use `final` for immutable variables
- Use `const` constructors when possible
- Prefer `is` over `as` for type checking

### Package Structure
- Main library file: `lib/supabase_error_translator_flutter.dart`
- Source files in `lib/src/`
- Models in `lib/src/models/`
- Data files in `lib/src/data/`
- Exceptions in `lib/src/exceptions/`

### Documentation
- Add documentation comments for all public APIs
- Use triple-slash comments (`///`) for documentation
- Include examples in documentation when helpful
- Document parameters and return values

### Testing
- Write comprehensive tests for all functionality
- Use descriptive test names
- Group related tests together
- Test both success and failure scenarios
- Include edge cases

## Key Components

### Models
- `SupportedLanguage`: Enum for supported languages
- `ErrorService`: Enum for Supabase services
- `TranslationResult`: Rich result object with metadata
- `TranslatorException`: Custom exception class

### Main Class
- `SupabaseErrorTranslator`: Main translator class with static methods
- Supports auto-detection of device language
- Implements 4-step fallback chain for translations

### Translation System
- `TranslationData`: Static class containing all translations
- Organized by language → service → error code
- Supports fallback to English if translation missing

## Error Handling

### Fallback Chain
1. Service-specific locale lookup
2. Service-specific English lookup
3. Generic locale fallback
4. Generic English fallback

### Error Codes
- Use snake_case for error codes
- Group by service (auth, database, storage, realtime, functions)
- Provide translations for all supported languages

## Common Patterns

### Adding New Languages
1. Add to `SupportedLanguage` enum
2. Update extension methods
3. Add translations to `TranslationData`
4. Add comprehensive tests
5. Update documentation

### Adding New Error Codes
1. Add to appropriate service section in `TranslationData`
2. Provide translations for all languages
3. Add tests for new error codes
4. Follow existing naming conventions

## Testing Guidelines

### Test Structure
- Use `group()` for organizing related tests
- Use descriptive test names that explain the scenario
- Test all public methods and edge cases
- Mock external dependencies when necessary

### Test Coverage
- Aim for high test coverage
- Test both positive and negative scenarios
- Include boundary conditions
- Test error handling and fallbacks

## Performance Considerations

- Translations are stored as static constants
- Lookup operations are O(1) for direct matches
- Memory usage is minimal with static data
- No network calls required for translations

## Localization Best Practices

### Translation Quality
- Use native speakers when possible
- Ensure cultural appropriateness
- Maintain consistency within languages
- Consider regional variations

### Error Messages
- Keep messages concise but informative
- Use user-friendly language
- Avoid technical jargon when possible
- Be consistent with tone and style

## Flutter Integration

### Compatibility
- Works with Flutter 3.0.0+
- Compatible with both internationalized and single-language apps
- Supports automatic device language detection
- No dependencies on external translation services

### Usage Patterns
- Simple translate() method for basic usage
- translateErrorCode() for detailed results
- Language management with auto-detection
- Integration with Supabase error handling

## Common Issues

### Language Detection
- Device language detection may not work in all environments
- Always provide fallback to English
- Handle edge cases gracefully

### Translation Fallbacks
- Implement proper fallback chain
- Never return null or empty strings
- Log when fallbacks are used for debugging

## Code Review Focus Areas

### Quality Checks
- Ensure all public APIs are documented
- Check test coverage for new features
- Verify proper error handling
- Confirm Flutter/Dart style compliance

### Translation Reviews
- Verify all languages are included
- Check translation accuracy
- Ensure consistent terminology
- Test with actual error scenarios

## Dependencies

### Required
- `flutter`: Flutter SDK
- `flutter_localizations`: For internationalization support
- `intl`: For internationalization utilities

### Dev Dependencies
- `flutter_test`: For testing
- `flutter_lints`: For code analysis

## Security Considerations

- No sensitive data in translations
- No network calls for translations
- All data is static and compile-time
- No user input validation required for translations

## Performance Optimization

- Use const constructors where possible
- Minimize memory allocations
- Cache language detection results
- Use efficient data structures for lookups
