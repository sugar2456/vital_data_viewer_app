import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class SleepRepositoryImpl extends BaseRequestClass
    implements SleepRepositoryInterface {
  final Map<String, String> headers;

  SleepRepositoryImpl({
    required this.headers,
    required super.client,
  });
  @override
  Future<SleepGoalResponse> fetchSleepGoal() async {
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');
    final responseBody = await super.get(uri, headers);
    return SleepGoalResponse.fromJson(responseBody);
  }

  @override
  Future<SleepLogResponse> fetchSleepLog() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final uri =
        Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');
    final responseBody = await super.get(uri, headers);
    return SleepLogResponse.fromJson(responseBody);
  }
}
