import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/models/response/steps_range_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/impls/base_request_class.dart';

class StepResponseImpl extends BaseRequestClass
    implements StepRepositoryInterface {
  final Map<String, String> headers;

  StepResponseImpl({
    required this.headers,
    required super.client,
  });
  @override
  Future<StepResponse> fetchStep(String date, String min) async {
    final uri = Uri.https(
        'api.fitbit.com', '/1/user/-/activities/steps/date/$date/1d/$min.json');

    final responseBody = await super.get(uri, headers);
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
  Future<StepResponse> fetchStepPeriod(
      String startDate, String endDate, String min) async {
    final uri = Uri.https('api.fitbit.com',
        '/1/user/-/activities/steps/date/$startDate/$endDate/$min.json');
    final responseBody = await super.get(uri, headers);
    return StepResponse.fromJson(responseBody);
  }

  @override
  Future<StepsRangeResponse> fetchStepsByDateRange(
      String startDate, String endDate) async {
    final uri = Uri.https('api.fitbit.com',
        '/1/user/-/activities/steps/date/$startDate/$endDate.json');
    final responseBody = await super.get(uri, headers);
    return StepsRangeResponse.fromJson(responseBody);
  }
}
