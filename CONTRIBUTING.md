# Contributing to Supabase Error Translator Flutter

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Ways to Contribute

### 1. Report Bugs
- Use the GitHub issue tracker to report bugs
- Include detailed steps to reproduce the issue
- Provide Flutter version and device information
- Include relevant error messages and stack traces

### 2. Request Features
- Use the GitHub issue tracker to suggest new features
- Clearly describe the feature and its use case
- Explain how it would benefit users

### 3. Add New Languages
- See the [Translation Guide](TRANSLATION_GUIDE.md) for detailed instructions
- Follow the existing translation patterns
- Ensure all error codes are translated
- Add comprehensive tests for the new language

### 4. Improve Existing Translations
- Native speakers can help improve translation quality
- Submit corrections for mistranslated error messages
- Ensure cultural appropriateness of translations

### 5. Add New Error Codes
- Submit new Supabase error codes that should be supported
- Provide translations for all supported languages
- Follow the existing error code naming conventions

## Development Setup

### Prerequisites
- Flutter 3.16.0 or higher
- Dart 3.0.0 or higher
- Git

### Setup Steps

1. **Fork the repository**
   ```bash
   # Clone your fork
   git clone https://github.com/your-username/supabase_error_translator_flutter.git
   cd supabase_error_translator_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Run the example**
   ```bash
   cd example
   flutter run
   ```

## Code Style

### Formatting
- Use `dart format` to format your code
- Follow the existing code style in the project
- Use single quotes for strings
- Add trailing commas for better diffs

### Linting
- Follow the rules in `analysis_options.yaml`
- Run `dart analyze` to check for issues
- Fix all linting errors before submitting

### Documentation
- Add documentation comments for all public APIs
- Follow Dart documentation conventions
- Include examples in documentation when helpful
- Update README.md if adding new features

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/supabase_error_translator_flutter_test.dart
```

### Test Requirements
- All new features must have comprehensive tests
- Maintain or improve test coverage
- Test both success and failure scenarios
- Include edge cases in tests

### Test Structure
- Use descriptive test names
- Group related tests together
- Follow the existing test patterns
- Test all public APIs

## Pull Request Process

### Before Submitting
1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the code style guidelines
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**
   ```bash
   flutter test
   dart analyze
   dart format --set-exit-if-changed .
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

### Commit Message Format
Follow the conventional commits format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test changes
- `refactor:` for code refactoring
- `style:` for formatting changes
- `chore:` for maintenance tasks

### Pull Request Guidelines
1. **Create a clear PR title and description**
   - Explain what the PR does
   - Reference any related issues
   - Include screenshots if applicable

2. **Ensure CI passes**
   - All tests must pass
   - Code must be properly formatted
   - No linting errors

3. **Request review**
   - Wait for maintainer review
   - Address any feedback promptly
   - Be responsive to questions

## Adding New Languages

### Step-by-Step Process

1. **Add language to enum**
   ```dart
   // In lib/src/models/supported_language.dart
   enum SupportedLanguage {
     // ... existing languages
     it, // Italian
   }
   ```

2. **Update extension methods**
   ```dart
   // Add to all switch statements in extension
   case SupportedLanguage.it:
     return 'it'; // or 'Italiano' for display name
   ```

3. **Add translations**
   ```dart
   // In lib/src/data/translation_data.dart
   'it': {
     'unknown_error': 'Si è verificato un errore sconosciuto',
     'services': {
       // ... add all service translations
     },
   },
   ```

4. **Add tests**
   ```dart
   test('should translate to Italian', () {
     SupabaseErrorTranslator.setLanguage(SupportedLanguage.it);
     final result = SupabaseErrorTranslator.translateErrorCode(
       'email_not_confirmed',
       ErrorService.auth,
     );
     expect(result.message, 'Email non confermata');
   });
   ```

5. **Update documentation**
   - Add language to README.md supported languages table
   - Update CHANGELOG.md
   - Add translation credits if applicable

### Translation Quality
- Use native speakers when possible
- Ensure cultural appropriateness
- Maintain consistency within the language
- Consider regional variations
- Test with actual users if possible

## Code Review Process

### For Contributors
- Be open to feedback
- Respond to comments promptly
- Make requested changes
- Ask questions if unclear

### For Reviewers
- Be constructive and helpful
- Explain the reasoning behind feedback
- Recognize good work
- Focus on code quality and maintainability

## Release Process

### Version Numbering
- Follow semantic versioning (SemVer)
- Major version for breaking changes
- Minor version for new features
- Patch version for bug fixes

### Release Steps
1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create GitHub release
4. Publish to pub.dev

## Community Guidelines

### Be Respectful
- Treat all contributors with respect
- Be inclusive and welcoming
- Help newcomers get started
- Give constructive feedback

### Stay On Topic
- Keep discussions relevant to the project
- Use appropriate channels for different topics
- Be clear and concise in communications

### Follow the Code of Conduct
- Maintain a harassment-free environment
- Be professional in all interactions
- Report any inappropriate behavior

## Getting Help

### Resources
- Check the [README.md](README.md) for basic usage
- Read the [Translation Guide](TRANSLATION_GUIDE.md) for translation help
- Look at existing issues and PRs for examples
- Check the test files for usage patterns

### Asking Questions
- Search existing issues first
- Provide detailed context
- Include relevant code snippets
- Be specific about what you need help with

### Contact
- Create an issue for project-related questions
- Use discussions for general questions
- Tag maintainers when appropriate

## Recognition

We appreciate all contributions and will recognize contributors in:
- CHANGELOG.md for significant contributions
- README.md for major features or languages
- GitHub releases for notable contributions

Thank you for contributing to make this project better for everyone!
