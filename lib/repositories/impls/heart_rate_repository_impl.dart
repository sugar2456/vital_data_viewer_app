import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class HeartRateRepositoryImpl extends BaseRequestClass implements HeartRateRepositoryInterdace {
  final Map<String, String> headers;

  HeartRateRepositoryImpl({
    required this.headers,
    required super.client,
  });
  @override
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/heart/date/$date/1d/$detailLevel.json');
    final responseBody = await super.get(uri, headers);
    return HeartRateResponse.fromJson(responseBody);
  }
}