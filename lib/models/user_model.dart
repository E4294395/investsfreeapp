class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String referralCode;
  final double balance;
  final String? image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.referralCode,
    required this.balance,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 1,
      username: json['username'] ?? 'DummyUser',
      email: json['email'] ?? 'dummy@example.com',
      phone: json['phone'] ?? '1234567890',
      referralCode: json['referral_code'] ?? 'DUMMY123',
      balance: (json['balance'] ?? 0.0).toDouble(),
      image: json['image'],
    );
  }
}