import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class BodyGoalRepositoryImpl extends BodyGoalRepositoryInterface {
  @override
  Future<BodyGoalResponse> fetchBodyGoal() async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/body/log/weight/goal.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return BodyGoalResponse.fromJson(responseBody['goal']);
      } else {
        log(response.statusCode.toString());
        throw Exception('Failed to load body goal');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load body goal');
    }
  }
}