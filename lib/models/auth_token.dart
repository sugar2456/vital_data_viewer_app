class AuthToken {
  final String token;
  final DateTime expiry;

  AuthToken({required this.token, required this.expiry});

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['token'],
      expiry: DateTime.parse(json['expiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiry': expiry.toIso8601String(),
    };
  }
}