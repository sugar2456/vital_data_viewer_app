import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class SwimmingRepositoryImpl extends SwimmingRepositoryInterface {
  @override
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel) async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/swimming-strokes/date/$date/1d/$detailLevel.json');
    final headers = HeaderUtil.createAuthHeaders();
    final httpUtil = HttpUtil(client: http.Client());
    final responseBody = await httpUtil.get(uri, headers);
    return SwimmingResponse.fromJson(responseBody);
  }
}