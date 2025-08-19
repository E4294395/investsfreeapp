import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added import
import '../services/api_service.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTransactions(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      _transactions = await _api.fetchTransactions(token);
    } catch (e) {
      _error = e.toString().contains('Network')
          ? 'Network error. Please check your connection.'
          : 'Failed to fetch transactions. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeDeposit(BuildContext context, Map<String, dynamic> body) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      await _api.makeDeposit(body, token);
      await fetchTransactions(context); // Refresh transactions
    } catch (e) {
      _error = e.toString().contains('Network')
          ? 'Network error. Please check your connection.'
          : 'Deposit failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeWithdraw(BuildContext context, Map<String, dynamic> body) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      await _api.makeWithdraw(body, token);
      await fetchTransactions(context); // Refresh transactions
    } catch (e) {
      _error = e.toString().contains('Network')
          ? 'Network error. Please check your connection.'
          : 'Withdrawal failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}