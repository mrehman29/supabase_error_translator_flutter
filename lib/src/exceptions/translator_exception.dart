/// Exception thrown when translation operations fail.
class TranslatorException implements Exception {
  /// Creates a new [TranslatorException].
  const TranslatorException(this.message, [this.originalError]);

  /// The error message.
  final String message;

  /// The original error that caused this exception (if any).
  final Object? originalError;

  @override
  String toString() {
    if (originalError != null) {
      return 'TranslatorException: $message (caused by: $originalError)';
    }
    return 'TranslatorException: $message';
  }
}
