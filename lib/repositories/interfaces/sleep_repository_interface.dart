import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';

abstract class SleepRepositoryInterface {
  Future<SleepGoalResponse> fetchSleepGoal();
  Future<SleepLogResponse> fetchSleepLog();
}