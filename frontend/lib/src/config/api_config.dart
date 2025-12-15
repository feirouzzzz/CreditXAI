/// API Configuration for the ML Backend
class ApiConfig {
  /// Base URL for the ML API
  /// Change this to your actual backend URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  /// Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// API Endpoints
  static const String predict = '/ml/predict';
  static const String explainShap = '/ml/explain';
  static const String fairnessMetrics = '/ml/fairness';
  static const String modelHealth = '/ml/health';
  static const String modelInfo = '/ml/info';
  
  /// Feature importance endpoints
  static const String featureImportance = '/ml/feature-importance';
  
  /// Batch prediction endpoint
  static const String batchPredict = '/ml/batch-predict';

  /// API Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Check if running in production
  static bool get isProduction =>
      const bool.fromEnvironment('dart.vm.product');

  /// Enable logging in debug mode
  static bool get enableLogging => !isProduction;
}
