import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/models/response/device_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/device_repository_interdace.dart';

class DeviceRepositoryImpl extends DeviceRepositoryInterface {
  Future<DeviceResponse> fetchDevice() async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/devices.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return DeviceResponse.fromJson(responseBody[0]);
      } else {
        print(response.statusCode);
        throw Exception('Failed to load device');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load device');
    }
  }
}