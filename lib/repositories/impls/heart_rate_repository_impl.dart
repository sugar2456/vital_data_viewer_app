import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/error/api_error_response.dart';
import 'dart:developer';
import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class HeartRateRepositoryImpl extends HeartRateRepositoryInterdace {
  @override
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/heart/date/$date/1d/$detailLevel.json');
    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return HeartRateResponse.fromJson(responseBody);
      } else {
        final errorResponseJson = json.decode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
        log('ステータスエラー：${errorResponse.success}');
        log('エラータイプ：${errorResponse.errors[0].errorType}');
        log('エラーメッセージ：${errorResponse.errors[0].message}');
        throw Exception('ステータスエラー: 心拍数の取得に失敗');
      }
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      throw Exception('心拍数の取得に失敗');
    }
  }
}