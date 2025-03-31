import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class SleepRepositoryImpl extends SleepRepositoryInterface {
  @override
  Future<SleepGoalResponse> fetchSleepGoal() async {
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');
    final headers = HeaderUtil.createAuthHeaders();
    final responseBody = await HttpUtil.get(uri, headers);
    return SleepGoalResponse.fromJson(responseBody['goal']);
  }

  @override
  Future<SleepLogResponse> fetchSleepLog() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');
    final headers = HeaderUtil.createAuthHeaders();
    final responseBody = await HttpUtil.get(uri, headers);
    return SleepLogResponse.fromJson(responseBody['sleep']);
  }
}