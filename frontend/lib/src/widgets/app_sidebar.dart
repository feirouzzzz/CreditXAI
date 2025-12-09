import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final Function(String) onNavigate;
  const AppSidebar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Admin',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _item(context, 'Dashboard', Icons.dashboard, '/admin/dashboard'),
          _item(context, 'Applications', Icons.list_alt, '/admin/applications'),
          _item(context, 'Models', Icons.memory, '/admin/models'),
          _item(context, 'Analytics', Icons.show_chart, '/admin/dashboard'),
          _item(context, 'Settings', Icons.settings, '/admin/settings'),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext c, String label, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => onNavigate(route),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
