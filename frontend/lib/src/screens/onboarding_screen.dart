import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      {
        'title': 'Ethical AI Credit Scoring',
        'subtitle': 'A fairer, transparent approach to credit decisions',
        'asset': 'assets/lottie/onboarding1.json',
        'colors': [const Color(0xFF0A1212), const Color(0xFF123B30)],
      },
      {
        'title': 'Explainable Decisions',
        'subtitle':
            'Understand how your score is computed with AI-driven insights',
        'asset': 'assets/lottie/onboarding2.json',
        'colors': [const Color(0xFF061916), const Color(0xFF1B3F34)],
      },
      {
        'title': 'Improve Your Finances',
        'subtitle': 'Get personalized guidance to grow your score over time',
        'asset': 'assets/lottie/onboarding3.json',
        'colors': [const Color(0xFF072023), const Color(0xFF17433A)],
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() {}),
                itemBuilder: (context, index) {
                  final p = pages[index];
                  return _buildStyledPage(
                    title: p['title'] as String,
                    subtitle: p['subtitle'] as String,
                    asset: p['asset'] as String,
                    colors: p['colors'] as List<Color>,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 18,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width:
                              _controller.hasClients &&
                                  (_controller.page ?? 0).round() == i
                              ? 36
                              : 12,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _controller.hasClients &&
                                    (_controller.page ?? 0).round() == i
                                ? Colors.tealAccent
                                : Colors.white54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if ((_controller.page ?? 0).round() ==
                                pages.length - 1) {
                              context.go('/login');
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF23F6D9),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF23F6D9,
                                  ).withAlpha((0.18 * 255).round()),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledPage({
    required String title,
    required String subtitle,
    required String asset,
    required List<Color> colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // illustration square
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.04 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Lottie.asset(
                        asset,
                        repeat: true,
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // glass card
              _buildGlassCard(title: title, subtitle: subtitle),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required String title, required String subtitle}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.04 * 255).round()),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withAlpha((0.03 * 255).round()),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
