class LoginResponse {
  final String token;
  final String tokenType;

  LoginResponse({required this.token, required this.tokenType});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': token,
      'token_type': tokenType,
    };
  }
}