import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/models/response/swimming_range_response.dart';

abstract class SwimmingRepositoryInterface {
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel);

  /// 期間指定で水泳ストロークデータを取得する
  ///
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns [SwimmingRangeResponse] 期間内の日別水泳データ
  Future<SwimmingRangeResponse> fetchSwimmingByDateRange(String startDate, String endDate);
}