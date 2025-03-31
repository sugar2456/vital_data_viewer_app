import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/calories_repository_interdace.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class CaloriesRepositoryImpl extends CaloriesRepositoryInterdace {
  @override
  Future<CaloriesResponse> fetchCalories(String date, String detailLevel) async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/calories/date/$date/1d/$detailLevel.json');
    final headers = HeaderUtil.createAuthHeaders();

    final responseBody = await HttpUtil.get(uri, headers);
    return CaloriesResponse.fromJson(responseBody);
  }
}