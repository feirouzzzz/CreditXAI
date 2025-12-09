import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_service.dart';

class AdminApplicationDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;
  const AdminApplicationDetailScreen({super.key, required this.applicationId});

  @override
  ConsumerState<AdminApplicationDetailScreen> createState() =>
      _AdminApplicationDetailScreenState();
}

class _AdminApplicationDetailScreenState
    extends ConsumerState<AdminApplicationDetailScreen> {
  final _service = AdminService();
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getApplication(widget.applicationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Application ${widget.applicationId}')),
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (snapshotContext, snap) {
          if (snap.connectionState != ConnectionState.done)
            return const Center(child: CircularProgressIndicator());
          final app = snap.data;
          if (app == null)
            return const Center(child: Text('Application not found'));
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    title: Text('ID: ${app.id}'),
                    subtitle: Text('Amount: ${app.amount}'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: Text('Status: ${app.status}'),
                    subtitle: Text('Date: ${app.date}'),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _overrideDecision(app.id),
                  child: const Text('Override Decision'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _overrideDecision(String id) async {
    final ok = await _service.overrideDecision(id, 'MANUAL_REVIEW');
    if (!mounted) return;
    if (ok)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Decision overridden')));
  }
}
