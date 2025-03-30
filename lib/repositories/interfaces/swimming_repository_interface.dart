import 'package:vital_data_viewer_app/models/response/swimming_response.dart';

abstract class SwimmingRepositoryInterface {
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel);
}