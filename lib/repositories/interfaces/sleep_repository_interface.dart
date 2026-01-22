import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_range_response.dart';

abstract class SleepRepositoryInterface {
  Future<SleepGoalResponse> fetchSleepGoal();
  Future<SleepLogResponse> fetchSleepLog();

  /// 指定された日付の睡眠データを取得する
  ///
  /// [date] 日付文字列（YYYY-MM-DD形式）例: "2025-11-17"
  /// Returns [SleepLogResponse] 睡眠データ
  /// Throws [ArgumentError] 不正な日付形式
  /// Throws [ExternalServiceException] API エラー時
  Future<SleepLogResponse> fetchSleepLogByDate(String date);

  /// 期間指定で睡眠データを取得する
  ///
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns [SleepRangeResponse] 期間内の睡眠データ
  Future<SleepRangeResponse> fetchSleepByDateRange(String startDate, String endDate);
}
