import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class SleepRepositoryImpl extends BaseRequestClass
    implements SleepRepositoryInterface {
  final Map<String, String> headers;

  SleepRepositoryImpl({
    required this.headers,
    required super.client,
  });
  @override
  Future<SleepGoalResponse> fetchSleepGoal() async {
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');
    final responseBody = await super.get(uri, headers);

    // 空のレスポンスチェック
    if (responseBody.isEmpty) {
      throw Exception('睡眠目標が設定されていません。Fitbitアプリで睡眠目標を設定してください。');
    }

    // goalキーの存在チェック
    if (!responseBody.containsKey('goal') || responseBody['goal'] == null) {
      throw Exception('睡眠目標データの取得に失敗しました。APIレスポンス: $responseBody');
    }

    return SleepGoalResponse.fromJson(responseBody);
  }

  @override
  Future<SleepLogResponse> fetchSleepLog() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final uri =
        Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');
    final responseBody = await super.get(uri, headers);
    return SleepLogResponse.fromJson(responseBody);
  }

  @override
  Future<SleepLogResponse> fetchSleepLogByDate(String date) async {
    if (!_isValidDateFormat(date)) {
      throw ArgumentError('Invalid date format. Expected YYYY-MM-DD');
    }

    final uri = Uri.https(
      'api.fitbit.com',
      '/1.2/user/-/sleep/date/$date.json',
    );

    final responseBody = await super.get(uri, headers);

    if (responseBody.isEmpty) {
      throw Exception('睡眠データが取得できませんでした。');
    }

    return SleepLogResponse.fromJson(responseBody);
  }

  /// 日付形式のバリデーション（YYYY-MM-DD）
  bool _isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(date)) {
      return false;
    }

    // さらに日付として有効かチェック
    try {
      final parts = date.split('-');
      final month = int.parse(parts[1]);

      // 月の範囲チェック
      if (month < 1 || month > 12) {
        return false;
      }

      // DateTime.parseでパース可能かチェック
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }
}
