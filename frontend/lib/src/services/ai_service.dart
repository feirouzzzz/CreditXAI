import 'dart:async';
import '../providers.dart';

class AIService {
  Future<ScoreResult> predict(Map<String, dynamic> features) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Use computeScoreFromForm as dummy
    final result = computeScoreFromForm(features);
    return result;
  }

  Future<List<ShapValue>> explain(Map<String, dynamic> features) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return dummy shap values
    return [
      ShapValue('Income', 0.25),
      ShapValue('Debt Ratio', -0.18),
      ShapValue('Age', 0.05),
      ShapValue('Loan Amount', -0.08),
    ];
  }
}
