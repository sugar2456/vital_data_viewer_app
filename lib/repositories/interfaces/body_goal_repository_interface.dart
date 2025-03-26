
import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';

abstract class BodyGoalRepositoryInterface {
  Future<BodyGoalResponse> fetchBodyGoal();
}