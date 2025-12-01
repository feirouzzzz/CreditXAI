import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/glass_card.dart';
import '../widgets/score_gauge.dart';
import '../widgets/gradient_button.dart';
import '../widgets/section_header.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning, Alex',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your credit dashboard',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Row(
                children: [
                  ScoreGaugeWidget(score: 785, size: 160),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credit Score',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Excellent',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tabs
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'History'),
                      Tab(text: 'Profile'),
                    ],
                  ),
                  SizedBox(
                    height: 260,
                    child: TabBarView(
                      children: [
                        // Overview: recent activity
                        ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (c, i) => ListTile(
                            leading: CircleAvatar(child: Text('T${i + 1}')),
                            title: Text('Transaction ${i + 1}'),
                            subtitle: Text('Payment • ${(i + 1) * 20} USD'),
                            trailing: Text('-${(i + 1) * 20}\$'),
                          ),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: 4,
                        ),
                        // History
                        Center(
                          child: Text(
                            'History list — placeholder',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        // Profile
                        Center(
                          child: Text(
                            'Profile quick view',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: 'New Application',
                    onPressed: () => context.goNamed('userNew'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: 'Past Applications',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'Recent Applications'),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) => SizedBox(
                  width: 260,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Loan \$${5000 + i * 1500}'),
                        const SizedBox(height: 8),
                        Text('Status: ${i % 2 == 0 ? 'Approved' : 'Pending'}'),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
