import 'package:vital_data_viewer_app/models/manager/token_manager.dart';

class AuthManager {
  /// 認証済みかどうかを確認
  bool isAuthenticated() {
    final token = TokenManager().getToken();
    return token != null && token.isNotEmpty;
  }
}