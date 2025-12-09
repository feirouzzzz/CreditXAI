import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class ApplicationSummaryScreen extends StatelessWidget {
  const ApplicationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Personal Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Name: Alex Johnson'),
                  Text('DOB: 1990-04-12'),
                  Text('Email: alex.johnson@example.com'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Financial Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Income: 4200'),
                  Text('Employment: Full-time'),
                  Text('Assets: 12000'),
                  Text('Liabilities: 3000'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: false, onChanged: (v) {}),
                const Expanded(child: Text('I agree to Terms and Conditions')),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
