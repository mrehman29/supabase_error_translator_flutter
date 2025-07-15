import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Error Translator Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Supabase Error Translator Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  SupportedLanguage _selectedLanguage = SupportedLanguage.en;
  ErrorService _selectedService = ErrorService.auth;
  String _selectedErrorCode = 'email_not_confirmed';
  TranslationResult? _translationResult;
  bool _autoDetect = false;
  late TabController _tabController;

  final Map<ErrorService, List<String>> _errorCodesByService = {
    ErrorService.auth: [
      'email_not_confirmed',
      'invalid_credentials',
      'user_not_found',
      'user_already_exists',
      'password_too_short',
      'password_too_weak',
      'email_already_registered',
      'phone_already_registered',
      'signup_disabled',
      'too_many_requests',
      'session_expired',
      'token_expired',
      'invalid_token',
      'mfa_challenge_expired',
      'mfa_verification_failed',
      'oauth_provider_not_supported',
      'otp_expired',
      'over_email_send_rate_limit',
    ],
    ErrorService.database: [
      'connection_failed',
      'query_timeout',
      'duplicate_key',
      'foreign_key_violation',
      'not_null_violation',
      'unique_violation',
      'permission_denied',
      'syntax_error',
      'deadlock_detected',
      'connection_limit_exceeded',
      'table_not_found',
      'column_not_found',
    ],
    ErrorService.storage: [
      'bucket_not_found',
      'file_not_found',
      'bucket_already_exists',
      'file_already_exists',
      'file_size_limit_exceeded',
      'invalid_file_type',
      'permission_denied',
      'upload_failed',
      'download_failed',
      'quota_exceeded',
      'invalid_path',
      'service_unavailable',
    ],
    ErrorService.realtime: [
      'connection_failed',
      'channel_not_found',
      'subscription_failed',
      'unauthorized',
      'rate_limit_exceeded',
      'channel_limit_exceeded',
      'connection_limit_exceeded',
      'invalid_channel_name',
      'realtime_disabled',
      'websocket_error',
      'message_too_large',
    ],
    ErrorService.functions: [
      'function_not_found',
      'execution_failed',
      'timeout',
      'memory_limit_exceeded',
      'invalid_input',
      'permission_denied',
      'rate_limit_exceeded',
      'cold_start_timeout',
      'network_error',
      'internal_error',
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _translateError();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _translateError() {
    if (_autoDetect) {
      SupabaseErrorTranslator.setLanguage(null, autoDetect: true);
    } else {
      SupabaseErrorTranslator.setLanguage(_selectedLanguage);
    }

    final result = SupabaseErrorTranslator.translateErrorCode(
      _selectedErrorCode,
      _selectedService,
    );

    setState(() {
      _translationResult = result;
    });
  }

  Widget _buildTranslatorTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto-detect toggle
          Card(
            child: SwitchListTile(
              title: const Text('Auto-detect Device Language'),
              subtitle: const Text('Automatically use device language'),
              value: _autoDetect,
              onChanged: (bool value) {
                setState(() {
                  _autoDetect = value;
                });
                _translateError();
              },
            ),
          ),
          const SizedBox(height: 16),

          // Language selection
          if (!_autoDetect) ...[
            const Text('Select Language:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<SupportedLanguage>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  items: SupportedLanguage.values.map((SupportedLanguage lang) {
                    return DropdownMenuItem<SupportedLanguage>(
                      value: lang,
                      child: Text('${lang.code} - ${lang.displayName}'),
                    );
                  }).toList(),
                  onChanged: (SupportedLanguage? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                      _translateError();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Service selection
          const Text('Select Supabase Service:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<ErrorService>(
                value: _selectedService,
                isExpanded: true,
                items: ErrorService.values.map((ErrorService service) {
                  return DropdownMenuItem<ErrorService>(
                    value: service,
                    child: Text(_getServiceDisplayName(service)),
                  );
                }).toList(),
                onChanged: (ErrorService? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedService = newValue;
                      _selectedErrorCode = _errorCodesByService[newValue]!.first;
                    });
                    _translateError();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Error code selection
          const Text('Select Error Code:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: _selectedErrorCode,
                isExpanded: true,
                items: _errorCodesByService[_selectedService]!.map((String code) {
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(code),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedErrorCode = newValue;
                    });
                    _translateError();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Translation result
          const Text('Translation Result:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            color: _translationResult?.isFallback == true ? Colors.orange[50] : Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_translationResult != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _translationResult!.message,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _translationResult!.message));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Language: ${_translationResult!.language.displayName} (${_translationResult!.language.code})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (_translationResult!.isFallback)
                      const Row(
                        children: [
                          Icon(Icons.warning, size: 16, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            'Fallback translation used',
                            style: TextStyle(fontSize: 12, color: Colors.orange),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingTab() {
    final TextEditingController customCodeController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Test Custom Error Codes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter custom error code:'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customCodeController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., custom_error_code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (customCodeController.text.isNotEmpty) {
                        final result = SupabaseErrorTranslator.translateErrorCode(
                          customCodeController.text,
                          _selectedService,
                        );

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Translation Result'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Error Code: ${customCodeController.text}'),
                                Text('Service: ${_selectedService.name}'),
                                Text('Translation: ${result.message}'),
                                Text('Language: ${result.language.displayName}'),
                                Text('Is Fallback: ${result.isFallback}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Test Translation'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Quick Tests:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Test Unknown Error'),
                  subtitle: const Text('Test fallback system'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => _testUnknownError(),
                ),
                ListTile(
                  title: const Text('Test All Languages'),
                  subtitle: const Text('See translation in all languages'),
                  trailing: const Icon(Icons.language),
                  onTap: () => _testAllLanguages(),
                ),
                ListTile(
                  title: const Text('Test Null Values'),
                  subtitle: const Text('Test edge cases'),
                  trailing: const Icon(Icons.error),
                  onTap: () => _testNullValues(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Package Information:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Supported Languages:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ...SupportedLanguage.values.map(
                    (lang) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('• ${lang.displayName} (${lang.code})'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Supported Services:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ...ErrorService.values.map(
                    (service) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                          '• ${_getServiceDisplayName(service)} (${_errorCodesByService[service]!.length} error codes)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Settings:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Current Language: ${SupabaseErrorTranslator.getCurrentLanguage().displayName}'),
                  Text('Auto-detect: ${_autoDetect ? 'Enabled' : 'Disabled'}'),
                  Text('Selected Service: ${_getServiceDisplayName(_selectedService)}'),
                  Text('Selected Error: $_selectedErrorCode'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _testUnknownError() {
    final result = SupabaseErrorTranslator.translateErrorCode(
      'unknown_error_code_12345',
      _selectedService,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unknown Error Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Error Code: unknown_error_code_12345'),
            Text('Translation: ${result.message}'),
            Text('Language: ${result.language.displayName}'),
            Text('Is Fallback: ${result.isFallback}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _testAllLanguages() {
    final results = <String>[];

    for (final lang in SupportedLanguage.values) {
      SupabaseErrorTranslator.setLanguage(lang);
      final result = SupabaseErrorTranslator.translateErrorCode(
        _selectedErrorCode,
        _selectedService,
      );
      results.add('${lang.displayName}: ${result.message}');
    }

    // Reset to current language
    _translateError();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$_selectedErrorCode in All Languages'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(results[index]),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _testNullValues() {
    final results = <String>[];

    try {
      // Test null error code
      final result1 = SupabaseErrorTranslator.translateErrorCode(
        '',
        _selectedService,
      );
      results.add('Empty string: ${result1.message}');

      // Test with basic translate method
      final result2 = SupabaseErrorTranslator.translate(
        'invalid_credentials',
        ErrorService.auth,
      );
      results.add('Basic translate: $result2');
    } catch (e) {
      results.add('Error: $e');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edge Case Tests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: results.map((r) => Text(r)).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getServiceDisplayName(ErrorService service) {
    switch (service) {
      case ErrorService.auth:
        return 'Authentication';
      case ErrorService.database:
        return 'Database';
      case ErrorService.storage:
        return 'Storage';
      case ErrorService.realtime:
        return 'Realtime';
      case ErrorService.functions:
        return 'Functions';
    }
  }

  Widget _buildUsageTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Usage Examples:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Basic Usage
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Basic Usage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Simple error translation:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''// Import the package
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

// Translate an error message
String translatedMessage = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
);

print(translatedMessage); // "Invalid login credentials"''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''// Import the package
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

// Translate an error message
String translatedMessage = SupabaseErrorTranslator.translate(
  'invalid_credentials',
  ErrorService.auth,
);

print(translatedMessage); // "Invalid login credentials"'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Advanced Usage
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Advanced Usage with Translation Result',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Get detailed translation information:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''// Get detailed translation result
TranslationResult result = SupabaseErrorTranslator.translateErrorCode(
  'user_not_found',
  ErrorService.auth,
);

print('Message: \${result.message}');
print('Language: \${result.language.displayName}');
print('Is Fallback: \${result.isFallback}');

// Handle fallback scenarios
if (result.isFallback) {
  print('Translation not available in current language');
}''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''// Get detailed translation result
TranslationResult result = SupabaseErrorTranslator.translateErrorCode(
  'user_not_found',
  ErrorService.auth,
);

print('Message: \${result.message}');
print('Language: \${result.language.displayName}');
print('Is Fallback: \${result.isFallback}');

// Handle fallback scenarios
if (result.isFallback) {
  print('Translation not available in current language');
}'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Language Management
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3. Language Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Set language preferences:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''// Set specific language
SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);

// Auto-detect device language
SupabaseErrorTranslator.setLanguage(null, autoDetect: true);

// Check current language
SupportedLanguage currentLang = SupabaseErrorTranslator.getCurrentLanguage();
print('Current language: \${currentLang.displayName}');

// Reset to default (English)
SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''// Set specific language
SupabaseErrorTranslator.setLanguage(SupportedLanguage.es);

// Auto-detect device language
SupabaseErrorTranslator.setLanguage(null, autoDetect: true);

// Check current language
SupportedLanguage currentLang = SupabaseErrorTranslator.getCurrentLanguage();
print('Current language: \${currentLang.displayName}');

// Reset to default (English)
SupabaseErrorTranslator.setLanguage(SupportedLanguage.en);'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Real-world Integration
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('4. Real-world Integration with Supabase',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Handle Supabase errors in your app:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''// In your authentication service
class AuthService {
  Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      // Handle specific auth errors
      String errorMessage = _handleAuthError(error);
      throw Exception(errorMessage);
    }
  }
  
  String _handleAuthError(dynamic error) {
    String errorCode = _extractErrorCode(error);
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.auth,
    );
  }
}''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''// In your authentication service
class AuthService {
  Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      // Handle specific auth errors
      String errorMessage = _handleAuthError(error);
      throw Exception(errorMessage);
    }
  }
  
  String _handleAuthError(dynamic error) {
    String errorCode = _extractErrorCode(error);
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.auth,
    );
  }
}'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Error Handling Widget
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('5. Error Handling Widget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Create a reusable error display widget:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''class ErrorDisplay extends StatelessWidget {
  final String errorCode;
  final ErrorService service;
  
  const ErrorDisplay({
    Key? key,
    required this.errorCode,
    required this.service,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final result = SupabaseErrorTranslator.translateErrorCode(
      errorCode,
      service,
    );
    
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.red[600]),
                const SizedBox(width: 8),
                Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(result.message),
            if (result.isFallback)
              const Text(
                'Translation not available in current language',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}

// Usage:
ErrorDisplay(
  errorCode: 'invalid_credentials',
  service: ErrorService.auth,
)''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''class ErrorDisplay extends StatelessWidget {
  final String errorCode;
  final ErrorService service;
  
  const ErrorDisplay({
    Key? key,
    required this.errorCode,
    required this.service,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final result = SupabaseErrorTranslator.translateErrorCode(
      errorCode,
      service,
    );
    
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.red[600]),
                const SizedBox(width: 8),
                Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(result.message),
            if (result.isFallback)
              const Text(
                'Translation not available in current language',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}

// Usage:
ErrorDisplay(
  errorCode: 'invalid_credentials',
  service: ErrorService.auth,
)'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Best Practices
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('6. Best Practices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('• Set language preference in your app\'s initialization'),
                  const Text('• Use auto-detect for better user experience'),
                  const Text('• Handle fallback translations gracefully'),
                  const Text('• Cache translation results for better performance'),
                  const Text('• Use TranslationResult for detailed error handling'),
                  const Text('• Test with different languages during development'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''// Initialize in main.dart
void main() {
  // Set language preference on app start
  SupabaseErrorTranslator.setLanguage(null, autoDetect: true);
  
  runApp(MyApp());
}

// In your error handling
Future<void> handleError(dynamic error) async {
  final result = SupabaseErrorTranslator.translateErrorCode(
    extractErrorCode(error),
    determineService(error),
  );
  
  // Show user-friendly message
  showSnackBar(result.message);
  
  // Log technical details for debugging
  if (result.isFallback) {
    logger.warn('Translation fallback used for: \${error}');
  }
}''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''// Initialize in main.dart
void main() {
  // Set language preference on app start
  SupabaseErrorTranslator.setLanguage(null, autoDetect: true);
  
  runApp(MyApp());
}

// In your error handling
Future<void> handleError(dynamic error) async {
  final result = SupabaseErrorTranslator.translateErrorCode(
    extractErrorCode(error),
    determineService(error),
  );
  
  // Show user-friendly message
  showSnackBar(result.message);
  
  // Log technical details for debugging
  if (result.isFallback) {
    logger.warn('Translation fallback used for: \${error}');
  }
}'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Installation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Installation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('Add to your pubspec.yaml:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''dependencies:
  supabase_error_translator_flutter: ^1.0.0
  
# Then run:
flutter pub get''',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard('''dependencies:
  supabase_error_translator_flutter: ^1.0.0'''),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCodesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error Codes by Service',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Service selector
          DropdownButton<ErrorService>(
            value: _selectedService,
            onChanged: (ErrorService? newValue) {
              setState(() {
                _selectedService = newValue!;
                _selectedErrorCode = _errorCodesByService[_selectedService]!.first;
                _translateError();
              });
            },
            items: ErrorService.values.map<DropdownMenuItem<ErrorService>>((ErrorService value) {
              return DropdownMenuItem<ErrorService>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Error codes list
          Expanded(
            child: ListView.builder(
              itemCount: _errorCodesByService[_selectedService]!.length,
              itemBuilder: (context, index) {
                final errorCode = _errorCodesByService[_selectedService]![index];
                final result = SupabaseErrorTranslator.translateErrorCode(
                  errorCode,
                  _selectedService,
                );

                return Card(
                  child: ListTile(
                    title: Text(errorCode),
                    subtitle: Text(result.message),
                    trailing: result.isFallback
                        ? const Icon(Icons.warning, color: Colors.orange)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Translator'),
            Tab(text: 'Error Codes'),
            Tab(text: 'Testing'),
            Tab(text: 'Usage'),
            Tab(text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTranslatorTab(),
          _buildErrorCodesTab(),
          _buildTestingTab(),
          _buildUsageTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
