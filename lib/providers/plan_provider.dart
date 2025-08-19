import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added import
import '../services/api_service.dart';
import '../models/plan_model.dart';
import '../providers/auth_provider.dart';

class PlanProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<PlanModel> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<PlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlans(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      _plans = await _api.fetchPlans(token);
    } catch (e) {
      _error = e.toString().contains('Network')
          ? 'Network error. Please check your connection.'
          : 'Failed to fetch plans. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}