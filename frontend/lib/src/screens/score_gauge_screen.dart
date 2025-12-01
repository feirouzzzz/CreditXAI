import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';

class ScoreGaugeScreen extends StatelessWidget {
  const ScoreGaugeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071213), Color(0xFF133B2F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(140),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.03 * 255).round()),
                        borderRadius: BorderRadius.circular(140),
                      ),
                      child: const Center(
                        child: Text(
                          'Gauge',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GradientButton(label: 'Save Report', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
