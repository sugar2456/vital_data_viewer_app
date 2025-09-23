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

    // 空のレスポンスの場合（ユーザーが体重目標を設定していない）
    if (responseBody.isEmpty) {
      throw Exception('体重目標が設定されていません。Fitbitアプリで体重目標を設定してください。');
    }

    // goalキーの存在チェック
    if (!responseBody.containsKey('goal')) {
      throw Exception('体重目標データの取得に失敗しました。APIレスポンス: $responseBody');
    }

    if (responseBody['goal'] == null) {
      throw Exception('体重目標データが空です。');
    }

    return BodyGoalResponse.fromJson(responseBody['goal']);
  }
}
