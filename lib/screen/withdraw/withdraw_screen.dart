import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';
import '../../config/app_theme.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _additionalNoteController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  String? _error;
  String? _selectedMethod;

  // Withdraw constraints
  final double _minAmount = 10000.00;
  final double _maxAmount = 100000000.00;
  final double _fixedCharge = 50.00; // Example fixed charge

  // Available withdrawal methods
  final Map<String, Map<String, dynamic>> _withdrawMethods = {
    'bank': {
      'name': 'Bank Account',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'placeholder': 'Enter your bank account details',
      'description': 'Withdraw to your bank account',
      'processingTime': '3-5 business days',
    },
    'wallet': {
      'name': 'Wallet Address',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
      'placeholder': 'Enter your wallet address',
      'description': 'Withdraw to crypto wallet',
      'processingTime': '1-24 hours',
    },
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _additionalNoteController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  double get _currentBalance {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return user?.balance ?? 20.00; // Default to 20.00 if user balance is null
  }

  double _calculateFinalAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    return amount - _fixedCharge;
  }

  bool _isValidAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    return amount >= _minAmount && amount <= _maxAmount && amount <= _currentBalance;
  }

  Future<void> _makeWithdraw() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMethod == null) {
      setState(() {
        _error = 'Please select a withdrawal method';
      });
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (amount < _minAmount) {
      setState(() {
        _error = 'Minimum withdrawal amount is \$${_minAmount.toStringAsFixed(2)}';
      });
      return;
    }

    if (amount > _maxAmount) {
      setState(() {
        _error = 'Maximum withdrawal amount is \$${_maxAmount.toStringAsFixed(2)}';
      });
      return;
    }

    if (amount > _currentBalance) {
      setState(() {
        _error = 'Insufficient balance. Your current balance is \$${_currentBalance.toStringAsFixed(2)}';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final body = {
        'amount': _amountController.text,
        'method': _selectedMethod,
        'account_details': _accountController.text,
        'additional_note': _additionalNoteController.text,
        'charge': _fixedCharge.toString(),
        'final_amount': _calculateFinalAmount().toString(),
      };

      await Provider.of<TransactionProvider>(context, listen: false)
          .makeWithdraw(context, body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Withdrawal request submitted successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().contains('Network')
              ? 'Network error. Please check your connection.'
              : 'Withdrawal failed. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 80,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppTheme.text,
                      size: 18,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Request Withdrawal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Balance Section
                              _buildBalanceSection(),

                              const SizedBox(height: 24),

                              // Withdraw Method Selection
                              _buildMethodSelectionSection(),

                              const SizedBox(height: 24),

                              // Withdraw Amount Section
                              _buildAmountSection(),

                              const SizedBox(height: 24),

                              // Account Information Section
                              if (_selectedMethod != null) ...[
                                _buildAccountSection(),
                                const SizedBox(height: 24),
                              ],

                              // Additional Note Section
                              if (_selectedMethod != null) ...[
                                _buildAdditionalNoteSection(),
                                const SizedBox(height: 24),
                              ],

                              // Withdraw Summary Section
                              if (_selectedMethod != null && _amountController.text.isNotEmpty) ...[
                                _buildSummarySection(),
                                const SizedBox(height: 24),
                              ],

                              // Withdraw Instructions
                              _buildInstructionsSection(),

                              const SizedBox(height: 24),

                              // Error Display
                              if (_error != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _error!,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Submit Button
                              if (_selectedMethod != null)
                                _buildSubmitButton(),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.accent,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Balance',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${_currentBalance.toStringAsFixed(2)} USD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.trending_up,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Withdraw Method',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select method',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textDim,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: _withdrawMethods.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMethodCard(entry.key, entry.value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(String key, Map<String, dynamic> method) {
    final isSelected = _selectedMethod == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = key;
          _error = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.textDim.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (method['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                method['icon'] as IconData,
                color: method['color'] as Color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textDim,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Processing: ${method['processingTime']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.textDim,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Withdraw Amount',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              final amount = double.tryParse(value);
              if (amount == null) {
                return 'Please enter a valid amount';
              }
              if (amount < _minAmount) {
                return 'Minimum amount is \$${_minAmount.toStringAsFixed(2)}';
              }
              if (amount > _maxAmount) {
                return 'Maximum amount is \$${_maxAmount.toStringAsFixed(2)}';
              }
              if (amount > _currentBalance) {
                return 'Amount exceeds current balance';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Enter amount',
              labelStyle: TextStyle(color: AppTheme.textDim),
              prefixIcon: Icon(
                Icons.attach_money,
                color: AppTheme.primary,
              ),
              suffixText: 'USD',
              suffixStyle: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: AppTheme.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: \$${_minAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppTheme.textDim,
                  fontSize: 12,
                ),
              ),
              Text(
                'Max: \$${_maxAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppTheme.textDim,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    final method = _withdrawMethods[_selectedMethod]!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Account Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _selectedMethod == 'bank'
                    ? 'Please enter your bank account details'
                    : 'Please enter your wallet address';
              }
              return null;
            },
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 16,
            ),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: _selectedMethod == 'bank'
                  ? 'Bank account / wallet address'
                  : 'Account email / wallet address',
              labelStyle: TextStyle(color: AppTheme.textDim),
              hintText: method['placeholder'] as String,
              hintStyle: TextStyle(color: AppTheme.textDim.withOpacity(0.7)),
              prefixIcon: Icon(
                method['icon'] as IconData,
                color: AppTheme.primary,
              ),
              filled: true,
              fillColor: AppTheme.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalNoteSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Additional Note',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _additionalNoteController,
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 16,
            ),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Additional information (optional)',
              labelStyle: TextStyle(color: AppTheme.textDim),
              hintText: 'Add any additional notes for your withdrawal...',
              hintStyle: TextStyle(color: AppTheme.textDim.withOpacity(0.7)),
              prefixIcon: Icon(
                Icons.edit_note,
                color: AppTheme.primary,
              ),
              filled: true,
              fillColor: AppTheme.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final finalAmount = _calculateFinalAmount();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withOpacity(0.1),
            AppTheme.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Withdrawal Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Withdraw Amount', '\$${amount.toStringAsFixed(2)} USD'),
          _buildSummaryRow('Withdraw Charge', 'Fixed - \$${_fixedCharge.toStringAsFixed(2)} USD'),
          const Divider(color: AppTheme.textDim),
          _buildSummaryRow(
            'Final Withdraw Amount',
            '\$${finalAmount.toStringAsFixed(2)} USD',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textDim,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isTotal ? AppTheme.primary : AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Withdraw Instructions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
            ),
            child: Text(
              'Please send us your wallet address or bank account number. Make sure all information is correct as withdrawal requests cannot be modified once submitted.',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _selectedMethod != null &&
        _accountController.text.isNotEmpty &&
        _isValidAmount();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isLoading || !isValid) ? null : _makeWithdraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: isValid ? AppTheme.primary : AppTheme.textDim,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: AppTheme.primary.withOpacity(0.4),
        ),
        child: _isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Submit Withdrawal Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}