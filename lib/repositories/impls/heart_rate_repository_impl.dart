import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class HeartRateRepositoryImpl extends HeartRateRepositoryInterdace {
  @override
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/heart/date/$date/1d/$detailLevel.json');
    final headers = HeaderUtil.createAuthHeaders();
    final responseBody = await HttpUtil.get(uri, headers);
    return HeartRateResponse.fromJson(responseBody);
  }
}