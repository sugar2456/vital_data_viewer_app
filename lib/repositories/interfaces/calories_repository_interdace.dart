import 'package:vital_data_viewer_app/models/response/calories_response.dart';

abstract class CaloriesRepositoryInterdace {
  Future<CaloriesResponse> fetchCalories(String date, String detailLevel);
}