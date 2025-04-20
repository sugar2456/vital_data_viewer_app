import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/device_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/device_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class DeviceRepositoryImpl extends BaseRequestClass implements DeviceRepositoryInterface {
  final Map<String, String> headers;

  DeviceRepositoryImpl({
    required this.headers,
    required super.client,
  });
  @override
  Future<DeviceResponse> fetchDevice() async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/devices.json');
    final responseBody = await super.get(uri, headers);
    return DeviceResponse.fromJson(responseBody);
  }
}