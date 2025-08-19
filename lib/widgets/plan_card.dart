import 'package:flutter/material.dart';
import '../../models/plan_model.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(plan.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Min: \$${plan.minInvest} - Max: \$${plan.maxInvest}'),
            Text('Return: ${plan.returnInterest}% ${plan.times} times'),
            Text('Capital Back: ${plan.capitalBack ? 'Yes' : 'No'}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: const Text('Invest'),
        ),
      ),
    );
  }
}