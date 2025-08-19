class TransactionModel {
  final String transactionId;
  final String type;
  final double amount;
  final int status;
  final double charge;
  final String createdAt;

  TransactionModel({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.status,
    required this.charge,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'] ?? '0',
      type: json['type'] ?? 'unknown',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 0,
      charge: (json['charge'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] ?? '',
    );
  }
}