import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/util/http_util.dart';

class StepResponseImpl extends StepRepositoryInterface {
  @override
  Future<StepResponse> fetchStep(String date, String min) async{
    final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/steps/date/$date/1d/$min.json');
    final headers = HeaderUtil.createAuthHeaders();
    
    final responseBody = await HttpUtil.get(uri, headers);
    return StepResponse.fromJson(responseBody);
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
    final headers = HeaderUtil.createAuthHeaders();
    final responseBody = await HttpUtil.get(uri, headers);
    return StepResponse.fromJson(responseBody);
  }
}