class PlanModel {
  final String id;
  final String name;
  final double minAmount; // Matches db.json min_amount
  final double maxAmount; // Matches db.json max_amount
  final double minInvest; // New field for PlanCard
  final double maxInvest; // New field for PlanCard
  final double returnInterest; // New field for PlanCard
  final String times; // New field for PlanCard
  final bool capitalBack; // New field for PlanCard

  PlanModel({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.maxAmount,
    required this.minInvest,
    required this.maxInvest,
    required this.returnInterest,
    required this.times,
    required this.capitalBack,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] ?? '0',
      name: json['name'] ?? 'Unknown Plan',
      minAmount: (json['min_amount'] ?? 0.0).toDouble(),
      maxAmount: (json['max_amount'] ?? 0.0).toDouble(),
      minInvest: (json['min_amount'] ?? 0.0).toDouble(), // Default to min_amount
      maxInvest: (json['max_amount'] ?? 0.0).toDouble(), // Default to max_amount
      returnInterest: (json['returnInterest'] ?? 5.0).toDouble(), // Default 5%
      times: json['times'] ?? '1', // Default 1 time
      capitalBack: json['capitalBack'] ?? true, // Default true
    );
  }
}