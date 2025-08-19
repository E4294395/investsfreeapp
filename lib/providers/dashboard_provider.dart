import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added import
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic> get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboard(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      _dashboardData = await _api.fetchDashboard(token);
    } catch (e) {
      _error = e.toString().contains('Network')
          ? 'Network error. Please check your connection.'
          : 'Failed to fetch dashboard data. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}