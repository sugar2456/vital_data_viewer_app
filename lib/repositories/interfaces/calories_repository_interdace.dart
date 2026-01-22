import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/models/response/calories_range_response.dart';

abstract class CaloriesRepositoryInterdace {
  Future<CaloriesResponse> fetchCalories(String date, String detailLevel);

  /// 期間指定でカロリーデータを取得する
  ///
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns [CaloriesRangeResponse] 期間内の日別カロリーデータ
  Future<CaloriesRangeResponse> fetchCaloriesByDateRange(String startDate, String endDate);
}