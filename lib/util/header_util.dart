import 'package:vital_data_viewer_app/models/manager/token_manager.dart';

class HeaderUtil {
  /// トークンを含むヘッダーを生成
  static Map<String, String> createAuthHeaders() {
    final token = TokenManager().getToken(); // トークンを取得
    if (token == null || token.isEmpty) {
      throw Exception('トークンが存在しません');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}