import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';
import '../models/user_model.dart';

class AuthService {
  final Map<String, String> jsonHeaders = {"Content-Type": "application/json"};

  Future<Map<String, dynamic>> post(String url, Map body) async {
    final res = await http.post(Uri.parse(url), headers: jsonHeaders, body: jsonEncode(body));
    return _processResponse(res);
  }

  Map<String, dynamic> _processResponse(http.Response res) {
    final code = res.statusCode;
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (code >= 200 && code < 300) {
      return body is Map<String, dynamic> ? body : {"data": body};
    } else {
      throw Exception(body['message'] ?? 'API error: ${res.statusCode}');
    }
  }

  Future<String> login(String email, String password) async {
    final res = await post(ApiEndpoints.login, {"email": email, "password": password});
    return res['token'] ?? res['data']?['token'] ?? (throw Exception('No token received'));
  }

  Future<UserModel> signup(String name, String email, String phone, String password, [String? referralCode]) async {
    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      if (referralCode != null) "referral_code": referralCode,
    };
    final res = await post(ApiEndpoints.signup, body);
    return UserModel.fromJson(res['data'] ?? res);
  }
}