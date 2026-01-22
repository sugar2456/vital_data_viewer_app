import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/models/response/heart_rate_range_response.dart';

abstract class HeartRateRepositoryInterdace {
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel);

  /// 期間指定で心拍数データを取得する
  ///
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns [HeartRateRangeResponse] 期間内の日別心拍数データ
  Future<HeartRateRangeResponse> fetchHeartRateByDateRange(String startDate, String endDate);
}