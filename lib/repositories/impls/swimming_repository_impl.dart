import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class SwimmingRepositoryImpl extends BaseRequestClass
    implements SwimmingRepositoryInterface {
  final Map<String, String> headers;

  SwimmingRepositoryImpl({
    required this.headers,
    required super.client,
  });

  @override
  Future<SwimmingResponse> fetchSwimming(
      String date, String detailLevel) async {
    final uri = Uri.https('api.fitbit.com',
        '/1/user/-/activities/swimming-strokes/date/$date/1d/$detailLevel.json');
    final responseBody = await super.get(uri, headers);
    return SwimmingResponse.fromJson(responseBody);
  }
}
