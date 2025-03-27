import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/activity_summary_response.dart';

abstract class ActivityGoalRepositoryInterface {
  Future<AcitivityGoalResponse> fetchActivityGoal();
  Future<ActivitySummaryResponse> fetchActivitySummary();  
}