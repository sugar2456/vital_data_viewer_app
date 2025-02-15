import '../user.dart';
import '../auth_token.dart';

class LoginResponse {
  final User user;
  final AuthToken authToken;

  LoginResponse({required this.user, required this.authToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      authToken: AuthToken.fromJson(json['authToken']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'authToken': authToken.toJson(),
    };
  }
}