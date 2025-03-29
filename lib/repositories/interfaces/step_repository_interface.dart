import 'package:vital_data_viewer_app/models/response/step_response.dart';

abstract class StepRepositoryInterface {
  Future<StepResponse> fetchStep(String date, String min);
  Future<StepResponse> fetchStepPeriod(String startDate, String endDate, String min);
}