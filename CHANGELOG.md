# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-07-15

### Added
- 🚀 **New Storage Error Code**: Added support for HTTP 413 "File size exceeds the limit" error
  - Added `'413'` error code to all storage service translations
  - Complete translations available in all 9 supported languages
  - Provides user-friendly messages for file size limit exceeded errors

### Changed
- 📝 **Documentation Updates**: Updated funding information in package metadata
- 🔧 **Maintenance**: Cleaned up dependency management and build configuration

### Technical Details
- **Error Code Coverage**: Now includes HTTP status code errors for better Supabase integration
- **Translation Consistency**: All language files updated with the new error code
- **Zero Breaking Changes**: Fully backward compatible with existing implementations

### Supported Languages for New Error Code
- 🇺🇸 English: "File size exceeds the limit"
- 🇪🇸 Spanish: "El tamaño del archivo excede el límite"
- 🇫🇷 French: "La taille du fichier dépasse la limite"
- 🇩🇪 German: "Dateigröße überschreitet das Limit"
- 🇵🇹 Portuguese: "Tamanho do arquivo excede o limite"
- 🇵🇱 Polish: "Rozmiar pliku przekracza limit"
- 🇰🇷 Korean: "파일 크기가 제한을 초과합니다"
- 🇯🇵 Japanese: "ファイルサイズが制限を超えています"
- 🇨🇳 Chinese: "文件大小超过限制"

### Migration Guide
No migration required - this is a minor update that adds new functionality without breaking existing code.

## [1.0.1] - 2025-07-15

### Changed
- 📦 **Dependencies**: Simplified dependency management
  - Removed `flutter_localizations` dependency for lighter package footprint
  - Updated `intl` dependency to use flexible version constraint (`any`)
- 🔧 **Configuration**: Streamlined package configuration for better compatibility

### Technical Details
- **Package Size**: Reduced package size by removing unnecessary dependencies
- **Compatibility**: Improved compatibility with different Flutter versions
- **Zero Breaking Changes**: Maintains full backward compatibility

### Migration Guide
No migration required - this is a maintenance update that improves package efficiency.

## [1.0.0] - 2025-01-15

### Added
- 🌍 **Multi-language Support**: Complete translation support for 9 languages
  - English (en), Spanish (es), French (fr), German (de), Italian (it)
  - Portuguese (pt), Dutch (nl), Polish (pl), Russian (ru)

- 🎯 **Complete Supabase Service Coverage**:
  - **Auth**: Authentication, user management, MFA, rate limiting
  - **Database**: Connections, queries, constraints, permissions
  - **Storage**: Files, buckets, permissions, size limits
  - **Realtime**: Connections, subscriptions, channels, rate limiting
  - **Functions**: Execution, timeouts, networking, memory limits

- 🚀 **Core Features**:
  - Simple `translate()` method for basic usage
  - Rich `translateErrorCode()` method with metadata
  - Automatic device language detection
  - Manual language setting with enum or string codes
  - Temporary language override for specific translations
  - Comprehensive error handling with 4-step fallback system

- 🔧 **Developer Experience**:
  - Type-safe enums for languages and services
  - Comprehensive error code coverage (50+ error codes per service)
  - Rich `TranslationResult` class with metadata
  - Custom `TranslatorException` for error handling
  - Language validation and management utilities

- 🧪 **Testing & Quality**:
  - 31 comprehensive tests with 100% coverage
  - Edge case handling (null values, unknown codes)
  - Model validation and enum testing
  - Fallback system testing
  - Auto-detection functionality testing

- 📖 **Documentation**:
  - Complete API documentation with examples
  - Real-world Flutter integration examples
  - Comprehensive README with usage patterns
  - Example app demonstrating all features

### Technical Details
- **Minimum Flutter Version**: 3.0.0
- **Dart SDK**: >=2.17.0 <4.0.0
- **Dependencies**: Only Flutter SDK (no external dependencies)
- **Platform Support**: iOS, Android, Web, Desktop
- **Performance**: O(1) lookup time with static translations
- **Memory Usage**: Minimal - all translations are compile-time constants

### Supported Error Codes

#### Auth Service (25+ error codes)
- `email_not_confirmed`, `invalid_credentials`, `user_not_found`, `user_already_exists`
- `password_too_short`, `password_too_weak`, `email_already_registered`, `phone_already_registered`
- `invalid_phone`, `invalid_email`, `signup_disabled`, `email_rate_limit_exceeded`
- `sms_rate_limit_exceeded`, `too_many_requests`, `phone_exists`, `email_exists`
- `session_expired`, `token_expired`, `invalid_token`, `mfa_challenge_expired`
- `mfa_verification_failed`, `provider_disabled`, `oauth_callback_error`

#### Database Service (25+ error codes)
- `connection_failed`, `query_timeout`, `duplicate_key`, `foreign_key_violation`
- `not_null_violation`, `check_violation`, `unique_violation`, `permission_denied`
- `invalid_input`, `syntax_error`, `type_mismatch`, `out_of_range`
- `deadlock_detected`, `serialization_failure`, `connection_limit_exceeded`
- `disk_full`, `memory_exhausted`, `table_not_found`, `column_not_found`, `function_not_found`

#### Storage Service (20+ error codes)
- `file_not_found`, `bucket_not_found`, `file_already_exists`, `bucket_already_exists`
- `access_denied`, `invalid_token`, `file_size_exceeded`, `storage_quota_exceeded`
- `invalid_file_type`, `upload_failed`, `download_failed`, `delete_failed`
- `bucket_not_empty`, `invalid_bucket_name`, `database_error`, `internal_error`

#### Realtime Service (20+ error codes)
- `connection_failed`, `websocket_error`, `subscription_error`, `channel_error`
- `authorization_failed`, `realtime_disabled`, `tenant_not_found`, `connection_limit_exceeded`
- `channel_limit_exceeded`, `rate_limit_exceeded`, `database_error`, `cdc_stream_error`
- `replication_error`, `node_disconnected`, `migration_error`, `internal_error`

#### Functions Service (15+ error codes)
- `function_not_found`, `execution_error`, `timeout_error`, `memory_limit_exceeded`
- `permission_denied`, `invalid_input`, `network_error`, `internal_error`
- `function_disabled`, `invalid_function_name`, `deployment_error`, `runtime_error`

### Migration Guide
This is the initial release, so no migration is needed.

### Known Limitations
- Languages are limited to the 9 currently supported
- Error codes are predefined (no custom error codes yet)
- Translation context is service-based only

### Future Roadmap
- Additional language support (Japanese, Korean, Chinese)
- Custom error code support
- Integration with Flutter's Localizations
- Contextual error messages
- Error analytics and reporting

### Thanks
- Flutter and Supabase communities for inspiration
- All beta testers who provided feedback
- Contributors who helped with translations and testing
- bucket_not_found, file_not_found, bucket_already_exists, file_already_exists
- file_size_limit_exceeded, invalid_file_type, permission_denied, invalid_token
- upload_failed, download_failed, delete_failed, quota_exceeded
- invalid_path, operation_not_supported, bucket_not_empty, invalid_bucket_name
- file_corrupted, network_error, service_unavailable

#### Realtime Service
- connection_failed, channel_not_found, subscription_failed, unauthorized
- rate_limit_exceeded, channel_limit_exceeded, connection_limit_exceeded
- invalid_channel_name, tenant_not_found, realtime_disabled, websocket_error
- message_too_large, invalid_message_format, join_rate_limit, broadcast_failed
- presence_failed, node_disconnected, migration_failed, counter_tracking_error

#### Functions Service
- function_not_found, execution_failed, timeout, memory_limit_exceeded
- invalid_input, permission_denied, rate_limit_exceeded, cold_start_timeout
- network_error, internal_error
