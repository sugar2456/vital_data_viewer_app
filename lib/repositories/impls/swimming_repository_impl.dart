import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/error/api_error_response.dart';
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class SwimmingRepositoryImpl extends SwimmingRepositoryInterface {
  @override
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel) async {
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/swimming-strokes/date/$date/1d/$detailLevel.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return SwimmingResponse.fromJson(responseBody);
      } else {
        final errorResponseJson = json.decode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
        log('ステータスエラー：${errorResponse.success}');
        log('エラータイプ：${errorResponse.errors[0].errorType}');
        log('エラーメッセージ：${errorResponse.errors[0].message}');
        throw Exception('ステータスエラー：水泳情報の取得に失敗');
      }
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      throw Exception('水泳情報の取得に失敗');
    }
  }
}