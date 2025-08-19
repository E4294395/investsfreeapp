import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';


class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  String? _token;
  UserModel? _user;

  String? get token => _token;
  UserModel? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      // Fetch user data if needed
      try {
        _user = await _fetchUser();
      } catch (e) {
        // Handle error (e.g., token expired or invalid)
        _token = null;
        await prefs.remove('token');
      }
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _token = await _api.login(email, password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    _user = await _fetchUser();
    notifyListeners();
  }

  Future<void> signup(String name, String email, String phone, String password, [String? referral]) async {
    // Create body map, excluding referral_code if null
    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      if (referral != null) "referral_code": referral,
    };
    _user = await _api.signup(body);
    _token = await _api.login(email, password); // Auto-login after signup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    notifyListeners();
  }

  Future<UserModel> _fetchUser() async {
    // Assume endpoint /api/user to fetch full user
    final res = await _api.get('${ApiEndpoints.BASE_URL}/user', token: _token);
    return UserModel.fromJson(res['data']);
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}