import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class BodyGoalRepositoryImpl extends BodyGoalRepositoryInterface {
  @override
  Future<BodyGoalResponse> fetchBodyGoal() async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/body/log/weight/goal.json');
    final headers = HeaderUtil.createAuthHeaders();
    final responseBody = await HttpUtil.get(uri, headers);
    return BodyGoalResponse.fromJson(responseBody['goal']);
  }
}