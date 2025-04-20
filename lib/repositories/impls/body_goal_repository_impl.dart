import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class BodyGoalRepositoryImpl extends BaseRequestClass
    implements BodyGoalRepositoryInterface {
  final Map<String, String> headers;

  BodyGoalRepositoryImpl({
    required this.headers,
    required super.client,
  });

  @override
  Future<BodyGoalResponse> fetchBodyGoal() async {
    final uri =
        Uri.https('api.fitbit.com', '/1/user/-/body/log/weight/goal.json');
    final responseBody = await super.get(uri, headers);
    return BodyGoalResponse.fromJson(responseBody['goal']);
  }
}
