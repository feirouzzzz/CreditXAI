import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple models for the demo app.
class CreditApplication {
  final String id;
  final double amount;
  final DateTime date;
  final String status;

  CreditApplication({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class ShapValue {
  final String feature;
  final double value; // positive => supports approval, negative => opposes

  ShapValue(this.feature, this.value);
}

class ScoreResult {
  final int score; // 0-900
  final String status;
  final List<ShapValue> shapValues;

  ScoreResult({
    required this.score,
    required this.status,
    required this.shapValues,
  });
}

/// Dummy applications provider
final applicationsProvider =
    StateNotifierProvider<ApplicationsNotifier, List<CreditApplication>>(
      (ref) => ApplicationsNotifier(),
    );

class ApplicationsNotifier extends StateNotifier<List<CreditApplication>> {
  ApplicationsNotifier()
    : super(
        List.generate(
          6,
          (i) => CreditApplication(
            id: 'app-${i + 1}',
            amount: (1000 + i * 250).toDouble(),
            date: DateTime.now().subtract(Duration(days: i * 3)),
            status: i % 3 == 0
                ? 'Approved'
                : (i % 3 == 1 ? 'Pending' : 'Rejected'),
          ),
        ),
      );

  void add(CreditApplication app) {
    state = [app, ...state];
  }
}

/// Provider holding the latest score result
final latestScoreProvider = StateProvider<ScoreResult?>((ref) => null);

/// Theme mode provider to toggle light/dark from the UI
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// CTA variant provider: 0 = Variant A (neon-cyan), 1 = Variant B (warm-orange)
final ctaVariantProvider = StateProvider<int>((ref) => 0);

/// Simple function to compute a dummy score and SHAP values from a form map.
ScoreResult computeScoreFromForm(Map<String, dynamic> form) {
  final rnd = Random();
  // generate dummy SHAP values using some of the inputs
  final income = (form['income'] ?? 3000).toDouble();
  final debtRatio = (form['debtRatio'] ?? 0.3).toDouble();
  final age = (form['age'] ?? 30).toDouble();
  final loan = (form['loanAmount'] ?? 5000).toDouble();

  final incomeImpact = (income / 10000) * 200; // positive
  final debtImpact = (1 - debtRatio) * 200; // positive when low debt
  final ageImpact = ((age >= 25 && age <= 65) ? 100 : -50);
  final loanImpact = (loan < 10000 ? 50 : -100);

  final base = 400 + incomeImpact + debtImpact + ageImpact + loanImpact;
  final noise = rnd.nextInt(100) - 50;
  int score = base.round() + noise;
  score = score.clamp(0, 900);

  final shap = <ShapValue>[];
  shap.add(ShapValue('Income', (incomeImpact / 900) * 100));
  shap.add(ShapValue('Debt Ratio', (debtImpact / 900) * 100));
  shap.add(ShapValue('Age', (ageImpact / 900) * 100));
  shap.add(ShapValue('Loan Amount', (loanImpact / 900) * 100));
  shap.add(ShapValue('Random Model Noise', (noise / 900) * 100));

  final status = score > 500 ? 'Approved' : 'Rejected';

  return ScoreResult(score: score, status: status, shapValues: shap);
}
