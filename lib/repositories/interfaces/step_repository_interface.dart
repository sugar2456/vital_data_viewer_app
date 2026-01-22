import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/models/response/steps_range_response.dart';

abstract class StepRepositoryInterface {
  Future<StepResponse> fetchStep(String date, String min);
  Future<StepResponse> fetchStepPeriod(String startDate, String endDate, String min);

  /// 期間指定で日別歩数データを取得する
  ///
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns [StepsRangeResponse] 期間内の日別歩数データ
  Future<StepsRangeResponse> fetchStepsByDateRange(String startDate, String endDate);
}