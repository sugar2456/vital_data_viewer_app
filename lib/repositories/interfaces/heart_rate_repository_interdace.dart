import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';

abstract class HeartRateRepositoryInterdace {
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel);
}