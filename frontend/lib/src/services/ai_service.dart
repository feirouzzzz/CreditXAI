import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers.dart';

class AIService {
  // Configure this to your ML service URL
  // For local testing: http://10.0.2.2:8000 (Android emulator)
  // For device on same network: http://YOUR_PC_IP:8000
  static const String baseUrl = 'http://192.168.1.3:8000';

  Future<ScoreResult> predict(Map<String, dynamic> features) async {
    try {
      // Map Flutter form fields to ML model fields
      final mlFeatures = {
        'Age': features['age'] ?? 30,
        'Sex': features['gender'] ?? 'male',
        'Job': features['jobCategory'] ?? 2,
        'Housing': features['housing'] ?? 'own',
        'Saving accounts': _mapSavings(features['savings']),
        'Checking account': _mapChecking(features['checking']),
        'Credit_amount': features['loanAmount'] ?? 5000,
        'Duration': features['duration'] ?? 24,
        'Purpose': features['purpose'] ?? 'car',
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/predict'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(mlFeatures),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ScoreResult(
          score: (data['confidence'] * 100).toInt(),
          risk: data['prediction_label'] == 'Rejected' ? 'HIGH' : 'LOW',
          approved: data['prediction'] == 1,
          confidence: data['confidence'],
        );
      } else {
        throw Exception('ML Service error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local computation if ML service unavailable
      print('ML Service unavailable, using fallback: $e');
      await Future.delayed(const Duration(milliseconds: 700));
      return computeScoreFromForm(features);
    }
  }

  Future<List<ShapValue>> explain(Map<String, dynamic> features) async {
    try {
      final mlFeatures = {
        'Age': features['age'] ?? 30,
        'Sex': features['gender'] ?? 'male',
        'Job': features['jobCategory'] ?? 2,
        'Housing': features['housing'] ?? 'own',
        'Saving accounts': _mapSavings(features['savings']),
        'Checking account': _mapChecking(features['checking']),
        'Credit_amount': features['loanAmount'] ?? 5000,
        'Duration': features['duration'] ?? 24,
        'Purpose': features['purpose'] ?? 'car',
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/score'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(mlFeatures),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final explanation = data['explanation'];

        if (explanation != null && explanation['top_features'] != null) {
          return (explanation['top_features'] as List).take(5).map((f) {
            return ShapValue(
              f['feature'] as String,
              (f['abs_importance'] as num).toDouble(),
            );
          }).toList();
        }
      }
    } catch (e) {
      print('Explanation service unavailable, using fallback: $e');
    }

    // Fallback to dummy values
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      ShapValue('Age', 0.41),
      ShapValue('Duration', 0.20),
      ShapValue('Credit Amount', 0.19),
      ShapValue('Savings', 0.11),
      ShapValue('Job', 0.03),
    ];
  }

  String _mapSavings(dynamic value) {
    if (value == null) return 'moderate';
    if (value is num) {
      if (value > 10000) return 'rich';
      if (value > 5000) return 'moderate';
      if (value > 1000) return 'little';
      return 'NA';
    }
    return value.toString().toLowerCase();
  }

  String _mapChecking(dynamic value) {
    if (value == null) return 'moderate';
    if (value is num) {
      if (value > 5000) return 'rich';
      if (value > 1000) return 'moderate';
      if (value > 0) return 'little';
      return 'NA';
    }
    return value.toString().toLowerCase();
  }
}
