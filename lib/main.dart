import 'package:flutter/material.dart';
import 'package:investsfree_app/screen/dashboard/dashboard_screen.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/signup_screen.dart';
import 'screen/dashboard/dashboard_screen.dart' hide DashboardScreen;
import 'screen/plans/plans_screen.dart';
import 'screen/deposit/deposit_screen.dart';
import 'screen/withdraw/withdraw_screen.dart';
import 'screen/transactions/transactions_screen.dart';
import 'screen/referrals/referrals_screen.dart';
import 'screen/profile/profile_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'config/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/transaction_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadFromStorage()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/plans': (context) => const PlansScreen(),
          '/deposit': (context) => const DepositScreen(),
          '/withdraw': (context) => const WithdrawScreen(),
          '/transactions': (context) => const TransactionsScreen(),
          '/referrals': (context) => const ReferralsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}