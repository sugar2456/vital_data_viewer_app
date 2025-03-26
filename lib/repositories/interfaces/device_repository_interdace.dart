import 'package:vital_data_viewer_app/models/response/device_response.dart';

abstract class DeviceRepositoryInterface {
  Future<DeviceResponse> fetchDevice();
}