import 'dart:async';
import '../providers.dart';

class AdminService {
  Future<List<CreditApplication>> listApplications({
    int page = 0,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // In real implementation fetch from /api/admin/applications
    return [
      CreditApplication(
        id: 'app-1',
        amount: 5000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'APPROVED',
      ),
      CreditApplication(
        id: 'app-2',
        amount: 12000,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: 'REJECTED',
      ),
      CreditApplication(
        id: 'app-3',
        amount: 3000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'PENDING',
      ),
    ];
  }

  Future<CreditApplication?> getApplication(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return CreditApplication(
      id: id,
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'APPROVED',
    );
  }

  Future<bool> overrideDecision(String id, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }
}
