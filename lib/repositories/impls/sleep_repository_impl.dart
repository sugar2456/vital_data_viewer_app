import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class SleepRepositoryImpl extends SleepRepositoryInterface {
  @override
  Future<SleepGoalResponse> fetchSleepGoal() async {
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return SleepGoalResponse.fromJson(responseBody);
      } else {
        log(response.statusCode.toString());
        throw Exception('Failed to load sleep goal');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load sleep goal');
    }
  }

  @override
  Future<SleepLogResponse> fetchSleepLog() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return SleepLogResponse.fromJson(responseBody);
      } else {
        log(response.statusCode.toString());
        throw Exception('Failed to load sleep log');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load sleep log');
    }
  }
}