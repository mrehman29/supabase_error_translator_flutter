/// Enum representing the different Supabase services that can generate errors.
enum ErrorService {
  /// Authentication and user management errors
  auth,

  /// Database query errors
  database,

  /// File storage errors
  storage,

  /// Realtime subscription errors
  realtime,

  /// Edge Functions errors
  functions,
}

/// Extension methods for [ErrorService] enum.
extension ErrorServiceExtension on ErrorService {
  /// Returns the string representation of the service.
  String get name {
    switch (this) {
      case ErrorService.auth:
        return 'auth';
      case ErrorService.database:
        return 'database';
      case ErrorService.storage:
        return 'storage';
      case ErrorService.realtime:
        return 'realtime';
      case ErrorService.functions:
        return 'functions';
    }
  }

  /// Creates an [ErrorService] from a string.
  static ErrorService fromString(String service) {
    switch (service.toLowerCase()) {
      case 'auth':
        return ErrorService.auth;
      case 'database':
        return ErrorService.database;
      case 'storage':
        return ErrorService.storage;
      case 'realtime':
        return ErrorService.realtime;
      case 'functions':
        return ErrorService.functions;
      default:
        throw ArgumentError('Unknown service: $service');
    }
  }
}
