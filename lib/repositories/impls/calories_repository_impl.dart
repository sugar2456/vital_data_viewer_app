import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/models/response/calories_range_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/calories_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class CaloriesRepositoryImpl extends BaseRequestClass
    implements CaloriesRepositoryInterdace {
  final Map<String, String> headers;

  CaloriesRepositoryImpl({
    required this.headers,
    required super.client,
  });

  @override
  Future<CaloriesResponse> fetchCalories(
      String date, String detailLevel) async {
    final uri = Uri.https('api.fitbit.com',
        '/1/user/-/activities/calories/date/$date/1d/$detailLevel.json');
    final responseBody = await super.get(uri, headers);
    return CaloriesResponse.fromJson(responseBody);
  }

  @override
  Future<CaloriesRangeResponse> fetchCaloriesByDateRange(
      String startDate, String endDate) async {
    final uri = Uri.https('api.fitbit.com',
        '/1/user/-/activities/calories/date/$startDate/$endDate.json');
    final responseBody = await super.get(uri, headers);
    return CaloriesRangeResponse.fromJson(responseBody);
  }
}
