import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/error/api_error_response.dart';
import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class StepResponseImpl extends StepRepositoryInterface {
  @override
  Future<StepResponse> fetchStep(String date, String min) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/steps/date/$date/1d/$min.json');

    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return StepResponse.fromJson(responseBody);
      } else {
        final errorResponseJson = json.decode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
        log('ステータスエラー：${errorResponse.success}');
        log('エラータイプ：${errorResponse.errors[0].errorType}');
        log('エラーメッセージ：${errorResponse.errors[0].message}');
        throw Exception('ステータスエラー：歩数の取得に失敗');
      }
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      throw Exception('歩数の取得に失敗');
    }   
  }

  /// 指定した期間の歩数を取得するメソッド
  /// 日付を指定できるが24hを超えて指定することはできないので、
  /// 実質同日の指定期間を取得することになる
  /// 
  /// [startDate] : 開始日
  /// [endDate] : 終了日
  /// [min] : 分間隔
  /// [return] : StepResponse
  /// [throws] : Exception
  /// [throws] : ApiErrorResponse
  @override
  Future<StepResponse> fetchStepPeriod(String startDate, String endDate, String min) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/steps/date/$startDate/$endDate/$min.json');
    try {
      final response = await http.get(uri, headers: HeaderUtil.createAuthHeaders());
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return StepResponse.fromJson(responseBody);
      } else {
        final errorResponseJson = json.decode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
        log('ステータスエラー：${errorResponse.success}');
        log('エラータイプ：${errorResponse.errors[0].errorType}');
        log('エラーメッセージ：${errorResponse.errors[0].message}');
        throw Exception('ステータスエラー：歩数の取得に失敗');
      }
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      throw Exception('歩数の取得に失敗');
    }   
  }
}