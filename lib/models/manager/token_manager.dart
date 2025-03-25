class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;

  TokenManager._internal();

  String? _authToken;

  // トークンをメモリに保存
  void setToken(String token) {
    _authToken = token;
  }

  // トークンを取得
  String? getToken() {
    return _authToken;
  }

  // トークンを削除
  void deleteToken() {
    _authToken = null;
  }
}