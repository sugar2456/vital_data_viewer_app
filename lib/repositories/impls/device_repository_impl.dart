import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/models/response/device_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/device_repository_interdace.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class DeviceRepositoryImpl extends DeviceRepositoryInterface {
  @override
  Future<DeviceResponse> fetchDevice() async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/devices.json');
    final headers = HeaderUtil.createAuthHeaders();
    final httpUtil = HttpUtil(client: http.Client());
    final responseBody = await httpUtil.get(uri, headers);
    return DeviceResponse.fromJson(responseBody);
  }
}