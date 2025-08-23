import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/plan_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/plan_model.dart';
import '../../config/app_theme.dart';
import '../deposit/deposit_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Weekly', 'Monthly', 'Elite'];

  // Define the exchange plans
  final List<ExchangePlan> exchangePlans = [
    ExchangePlan(
      id: "1",
      name: "KUCOIN Exchange Plan",
      logoPath: 'assets/images/kucoin.png',
      logoColor: Color(0xFF24DC9C),
      minDeposit: 500,
      maxDeposit: 1000,
      returnRate: 2.85,
      frequency: "weekly",
      returnTimes: 52,
      description: "Start small, grow steadily. With just \$500 minimum, you can step into the world of owning exchange shares. KuCoin pays 2.85% weekly, giving you consistent, reliable passive income. Perfect for beginners who want to test the waters.",
      category: "Weekly",
    ),
    ExchangePlan(
      id: "2",
      name: "BITGET Exchange Plan",
      logoPath: 'assets/images/bitget.png',
      logoColor: Color(0xFF02F0FF),
      minDeposit: 1000,
      maxDeposit: 5000,
      returnRate: 3.80,
      frequency: "weekly",
      returnTimes: 52,
      description: "A stronger step forward. With deposits from \$1,000–\$5,000, Bitget rewards you with 3.80% weekly dividends. It's designed for those ready to move beyond entry-level and accelerate their wealth-building journey.",
      category: "Weekly",
    ),
    ExchangePlan(
      id: "3",
      name: "ROBINHOOD Exchange Plan",
      logoPath: 'assets/images/robinhood.png',
      logoColor: Color(0xFFCCFF02),
      minDeposit: 5000,
      maxDeposit: 10000,
      returnRate: 5.60,
      frequency: "weekly",
      returnTimes: 52,
      description: "Bridging stocks and crypto. With \$5,000–\$10,000, you tap into the Robinhood ecosystem and enjoy 5.60% weekly payouts. It's the choice for investors who understand both traditional stock investing and the new crypto economy.",
      category: "Weekly",
    ),
    ExchangePlan(
      id: "4",
      name: "CRYPTO.COM Exchange Plan",
      logoPath: 'assets/images/crypto.png',
      logoColor: Color(0xFF6F8BBA),
      minDeposit: 10000,
      maxDeposit: 20000,
      returnRate: 16.52,
      frequency: "monthly",
      returnTimes: 12,
      description: "Now we enter monthly payouts. Invest \$10,000–\$20,000 and receive a huge 16.52% monthly dividend. This is a serious wealth multiplier, designed for mid-level investors seeking higher returns while still playing safe with a global brand.",
      category: "Monthly",
    ),
    ExchangePlan(
      id: "5",
      name: "COINBASE Exchange Plan",
      logoPath: 'assets/images/coinbase.png',
      logoColor: Color(0xFF0253FE),
      minDeposit: 20000,
      maxDeposit: 50000,
      returnRate: 21.10,
      frequency: "monthly",
      returnTimes: 12,
      description: "For the bold and strategic. With \$20,000–\$50,000, Coinbase pays 21.10% monthly dividends. You're not just investing — you're becoming part of one of the most recognized crypto exchanges in the world.",
      category: "Monthly",
    ),
    ExchangePlan(
      id: "6",
      name: "BINANCE Exchange Plan",
      logoPath: 'assets/images/binance.png',
      logoColor: Color(0xFFF1B90E),
      minDeposit: 50000,
      maxDeposit: 100000,
      returnRate: 24.20,
      frequency: "monthly",
      returnTimes: 12,
      description: "The powerhouse. With \$50,000–\$100,000, Binance returns 24.20% monthly dividends. As the world's largest exchange, this plan is for investors who want dominance, scale, and maximum leverage in crypto.",
      category: "Monthly",
    ),
    ExchangePlan(
      id: "7",
      name: "SCFI 500 Exchange Plan",
      logoPath: 'assets/images/scfipro.png',
      logoColor: Color(0xFF04A2FD),
      minDeposit: 100000,
      maxDeposit: 1000000,
      returnRate: 25.0,
      frequency: "monthly",
      returnTimes: 12,
      description: "The elite circle. With \$100,000–\$1,000,000, this plan pays 25% monthly dividends — the highest tier available. Designed for visionaries and pioneers, the SCFI 500 isn't just an investment. It's a ticket into the future of wealth creation.",
      category: "Elite",
    ),
  ];

  List<ExchangePlan> _getFilteredPlans() {
    if (_selectedCategory == 'All') return exchangePlans;
    return exchangePlans.where((plan) => plan.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final filteredPlans = _getFilteredPlans();

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(context, auth),

              // Category Filter
              _buildCategoryFilter(),

              // Plans List
              Expanded(
                child: _buildPlansList(filteredPlans),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.text,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exchange Investment Plans',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text,
                  ),
                ),
                Text(
                  'Invest in top exchange shares',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDim,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                _showPlanComparisonDialog(context);
              },
              icon: const Icon(
                Icons.compare_arrows,
                color: AppTheme.text,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                )
                    : null,
                color: isSelected ? null : AppTheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlansList(List<ExchangePlan> plans) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      backgroundColor: AppTheme.surface,
      color: AppTheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          return _buildExchangePlanCard(plans[index], index);
        },
      ),
    );
  }

  Widget _buildExchangePlanCard(ExchangePlan plan, int index) {
    final isElite = plan.category == 'Elite';
    final isMonthly = plan.frequency == 'monthly';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: isElite
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            plan.logoColor.withOpacity(0.15),
            AppTheme.primary.withOpacity(0.1),
          ],
        )
            : null,
        color: isElite ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: isElite
            ? Border.all(
          color: plan.logoColor.withOpacity(0.3),
          width: 1.5,
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          if (isElite)
            BoxShadow(
              color: plan.logoColor.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Header with Exchange Logo
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: plan.logoColor.withOpacity(1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: plan.logoColor.withOpacity(1),
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        plan.logoPath,
                        fit: BoxFit.contain,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.text,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: plan.logoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: plan.logoColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '${plan.returnRate}% ${plan.frequency.toUpperCase()}',
                              style: TextStyle(
                                color: plan.logoColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Investment Range
                _buildPlanFeature(
                  Icons.account_balance_wallet,
                  'Investment Range',
                  '\$${_formatNumber(plan.minDeposit)} - \$${_formatNumber(plan.maxDeposit)}',
                  plan.logoColor,
                ),

                const SizedBox(height: 16),

                // Return Frequency
                _buildPlanFeature(
                  Icons.schedule,
                  'Payout Frequency',
                  '${plan.returnTimes} times ${plan.frequency}',
                  plan.logoColor,
                ),

                const SizedBox(height: 16),

                // Exchange Type
                _buildPlanFeature(
                  Icons.security,
                  'Exchange Type',
                  plan.name.split(' ')[0],
                  Colors.green,
                ),

                const SizedBox(height: 24),

                // Investment Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: plan.logoColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: plan.logoColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calculate,
                            color: plan.logoColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Investment Preview',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Minimum Investment',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textDim,
                                ),
                              ),
                              Text(
                                '\$${_formatNumber(plan.minDeposit)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: plan.logoColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: AppTheme.textDim,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${plan.frequency.capitalize()} Return',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textDim,
                                ),
                              ),
                              Text(
                                '\$${_formatNumber((plan.minDeposit * plan.returnRate / 100))}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  plan.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDim,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showExchangePlanDetails(plan),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: plan.logoColor,
                          side: BorderSide(color: plan.logoColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [plan.logoColor, plan.logoColor.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _investNow(plan),
                          icon: const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Invest Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Elite Badge
          if (isElite)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.crop_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ELITE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlanFeature(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textDim,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _investNow(ExchangePlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DepositScreen(),
        settings: RouteSettings(arguments: int.parse(plan.id)),
      ),
    );
  }

  void _showExchangePlanDetails(ExchangePlan plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.textDim.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: plan.logoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: plan.logoColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      plan.logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.text,
                          ),
                        ),
                        Text(
                          'Exchange Investment Plan',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppTheme.textDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppTheme.textDim),

            // Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      plan.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDim,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Investment Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailItem('Minimum Investment', '\$${_formatNumber(plan.minDeposit)}'),
                    _buildDetailItem('Maximum Investment', '\$${_formatNumber(plan.maxDeposit)}'),
                    _buildDetailItem('Return Rate', '${plan.returnRate}% ${plan.frequency}'),
                    _buildDetailItem('Return Frequency', '${plan.returnTimes} times per year'),
                    _buildDetailItem('Exchange', plan.name.split(' ')[0]),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: plan.logoColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: plan.logoColor.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: plan.logoColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Investment Security',
                                style: TextStyle(
                                  color: plan.logoColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your investment is backed by shares in one of the world\'s leading cryptocurrency exchanges. All investments are processed through secure, regulated channels.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textDim,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [plan.logoColor, plan.logoColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _investNow(plan);
                  },
                  icon: const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Start Investment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textDim,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPlanComparisonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Exchange Plans Comparison',
          style: TextStyle(color: AppTheme.text),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: exchangePlans.map((plan) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: plan.logoColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: plan.logoColor.withOpacity(0.2),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: plan.logoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      plan.logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    plan.name.split(' ')[0],
                    style: TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${plan.returnRate}% ${plan.frequency}',
                    style: TextStyle(color: plan.logoColor),
                  ),
                  trailing: Text(
                    '\${_formatNumber(plan.minDeposit)}+',
                    style: TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}

// Exchange Plan Model
class ExchangePlan {
  final String id;
  final String name;
  final String logoPath;
  final Color logoColor;
  final double minDeposit;
  final double maxDeposit;
  final double returnRate;
  final String frequency;
  final int returnTimes;
  final String description;
  final String category;

  ExchangePlan({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.logoColor,
    required this.minDeposit,
    required this.maxDeposit,
    required this.returnRate,
    required this.frequency,
    required this.returnTimes,
    required this.description,
    required this.category,
  });
}

// String extension for capitalize
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}