import 'dart:convert';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/plan_model.dart';
import '../config/api_endpoints.dart';

class ApiService {
  Future<String> login(String email, String password) async {
    print('Hitting URL: ${ApiEndpoints.login} (Mocked)');
    print('Request Body: ${jsonEncode({'email': email, 'password': password})}');
    try {
      final mockResponse = {
        'token': 'dummy_token_123'
      };
      print('Response Status: 200 (Mocked)');
      print('Response Body: ${jsonEncode(mockResponse)}');
      print('Response Headers: {content-type: application/json; charset=utf-8, access-control-allow-origin: *}');
      return mockResponse['token'] ?? 'dummy_token_123';
    } catch (e) {
      print('Error: $e');
      throw 'Login error: $e';
    }
  }

  Future<UserModel> signup(Map<String, dynamic> body) async {
    print('Hitting URL: ${ApiEndpoints.signup} (Mocked)');
    print('Request Body: ${jsonEncode(body)}');
    try {
      final mockResponse = {
        'data': {
          'id': 1,
          'username': body['username'] ?? 'NewUser',
          'email': body['email'] ?? 'newuser@example.com',
          'phone': body['phone'] ?? '1234567890',
          'referral_code': body['referral_code'] ?? 'NEW123',
          'balance': 0.0,
          'image': null
        }
      };
      print('Response Status: 201 (Mocked)');
      print('Response Body: ${jsonEncode(mockResponse)}');
      print('Response Headers: {content-type: application/json; charset=utf-8, access-control-allow-origin: *}');
      return UserModel.fromJson(mockResponse['data']!);
    } catch (e) {
      print('Error: $e');
      throw 'Signup error: $e';
    }
  }

  Future<Map<String, dynamic>> get(String url, {String? token}) async {
    print('Hitting URL: $url (Mocked)');
    try {
      Map<String, dynamic> mockResponse;
      switch (url) {
        case ApiEndpoints.profile:
          mockResponse = {
            'data': {
              'id': 1,
              'username': 'DummyUser',
              'email': 'dummy@example.com',
              'phone': '1234567890',
              'referral_code': 'DUMMY123',
              'balance': 1000.0,
              'image': null
            }
          };
          break;
        case ApiEndpoints.user: // Added for /user endpoint
          mockResponse = {
            'data': {
              'id': 1,
              'username': 'DummyUser',
              'email': 'dummy@example.com',
              'phone': '1234567890',
              'referral_code': 'DUMMY123',
              'balance': 1000.0,
              'image': null
            }
          };
          break;
        case ApiEndpoints.dashboard:
          mockResponse = {
            'data': {
              'balance': 1000.0,
              'transactions': 5,
              'total_deposits': 500.0,
              'total_withdrawals': 200.0
            }
          };
          break;
        case ApiEndpoints.plans:
          mockResponse = {
            'data': [
              {
                'id': '1',
                'name': 'Basic Plan',
                'min_amount': 10.0,
                'max_amount': 100.0,
                'returnInterest': 5.0,
                'times': '1',
                'capitalBack': true
              },
              {
                'id': '2',
                'name': 'Premium Plan',
                'min_amount': 100.0,
                'max_amount': 1000.0,
                'returnInterest': 10.0,
                'times': '2',
                'capitalBack': false
              }
            ]
          };
          break;
        case ApiEndpoints.transactions:
          mockResponse = {
            'data': [
              {
                'transactionId': '1',
                'type': 'deposit',
                'amount': 100.0,
                'status': 1,
                'charge': 5.0,
                'createdAt': '2025-01-01T10:00:00Z'
              },
              {
                'transactionId': '2',
                'type': 'withdraw',
                'amount': 50.0,
                'status': 0,
                'charge': 2.5,
                'createdAt': '2025-01-02T12:00:00Z'
              }
            ]
          };
          break;
        case ApiEndpoints.referrals:
          mockResponse = {
            'data': [
              {
                'id': 1,
                'username': 'Friend1',
                'created_at': '2025-01-01T10:00:00Z',
                'commission': 10.0
              },
              {
                'id': 2,
                'username': 'Friend2',
                'created_at': '2025-01-02T12:00:00Z',
                'commission': 15.0
              }
            ]
          };
          break;
        default:
          throw 'Unknown endpoint: $url';
      }
      print('Response Status: 200 (Mocked)');
      print('Response Body: ${jsonEncode(mockResponse)}');
      print('Response Headers: {content-type: application/json; charset=utf-8, access-control-allow-origin: *}');
      return mockResponse;
    } catch (e) {
      print('Error: $e');
      throw 'Get error: $e';
    }
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body, {String? token}) async {
    print('Hitting URL: $url (Mocked)');
    print('Request Body: ${jsonEncode(body)}');
    try {
      Map<String, dynamic> mockResponse;
      switch (url) {
        case ApiEndpoints.deposits:
          mockResponse = {
            'message': 'Deposit successful'
          };
          break;
        case ApiEndpoints.withdraws:
          mockResponse = {
            'message': 'Withdrawal successful'
          };
          break;
        default:
          throw 'Unknown endpoint: $url';
      }
      print('Response Status: 201 (Mocked)');
      print('Response Body: ${jsonEncode(mockResponse)}');
      print('Response Headers: {content-type: application/json; charset=utf-8, access-control-allow-origin: *}');
      return mockResponse;
    } catch (e) {
      print('Error: $e');
      throw 'Post error: $e';
    }
  }

  Future<List<TransactionModel>> fetchTransactions(String token) async {
    final res = await get(ApiEndpoints.transactions, token: token);
    return (res['data'] as List).map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<void> makeDeposit(Map<String, dynamic> body, String token) async {
    await post(ApiEndpoints.deposits, body, token: token);
  }

  Future<void> makeWithdraw(Map<String, dynamic> body, String token) async {
    await post(ApiEndpoints.withdraws, body, token: token);
  }

  Future<Map<String, dynamic>> fetchDashboard(String token) async {
    return await get(ApiEndpoints.dashboard, token: token);
  }

  Future<List<PlanModel>> fetchPlans(String token) async {
    final res = await get(ApiEndpoints.plans, token: token);
    return (res['data'] as List).map((e) => PlanModel.fromJson(e)).toList();
  }
}