import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/activity_summary_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';
import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class ActivityRepositoryImpl extends BaseRequestClass
    implements ActivityGoalRepositoryInterface {
  final Map<String, String> headers;

  ActivityRepositoryImpl({
    required this.headers,
    required super.client,
  }); 

  @override
  Future<AcitivityGoalResponse> fetchActivityGoal() async {
    final uri =
        Uri.https('api.fitbit.com', '/1/user/-/activities/goals/daily.json');
    final responseBody = await super.get(uri, headers);
    return AcitivityGoalResponse.fromJson(responseBody['goals']);
  }

  @override
  Future<ActivitySummaryResponse> fetchActivitySummary() async {
    // 今日の日付 yyyy-MM-dd
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final uri =
        Uri.https('api.fitbit.com', '/1/user/-/activities/date/$date.json');
    final responseBody = await super.get(uri, headers);
    return ActivitySummaryResponse.fromJson(responseBody);
  }
}
