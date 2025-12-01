import 'package:flutter/material.dart';

/// Admin dashboard with responsive grid and dummy metrics.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Widget _card(String title, Widget child) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 1000
                ? 3
                : (constraints.maxWidth > 700 ? 2 : 1);
            return GridView.count(
              crossAxisCount: cols,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _card(
                  'Recent Scorings',
                  ListView.builder(
                    itemCount: 5,
                    itemBuilder: (c, i) => ListTile(
                      title: Text('Applicant #${i + 1}'),
                      subtitle: Text('Score: ${600 - i * 30}'),
                    ),
                  ),
                ),
                _card(
                  'Model Version',
                  Center(child: Text('v1.2.3 (explainable)')),
                ),
                _card(
                  'Fairness Metrics',
                  Column(
                    children: [
                      LinearProgressIndicator(value: 0.72),
                      const SizedBox(height: 8),
                      const Text('Parity: 72%'),
                    ],
                  ),
                ),
                _card('Throughput', Center(child: Text('120 req/min'))),
                _card('Alerts', Center(child: Text('No critical alerts'))),
                _card('Notes', Center(child: Text('All systems nominal'))),
              ],
            );
          },
        ),
      ),
    );
  }
}
