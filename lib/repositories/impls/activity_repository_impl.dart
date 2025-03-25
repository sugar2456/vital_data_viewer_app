import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';
import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';


class ActivityRepositoryImpl implements ActivityGoalRepositoryInterface {
  @override
  Future<AcitivityGoalResponse> fetchActivityGoal() async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/goals/daily.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return AcitivityGoalResponse.fromJson(responseBody['goals']);
      } else {
        print(response.statusCode);
        throw Exception('Failed to load activity goal');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load activity goal');
    }
  }
}