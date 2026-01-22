import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';

/// 期間指定睡眠APIのレスポンスモデル
/// GET /1.2/user/-/sleep/date/{start}/{end}.json
class SleepRangeResponse {
  final List<Sleep> sleep;

  SleepRangeResponse({
    required this.sleep,
  });

  factory SleepRangeResponse.fromJson(Map<String, dynamic> json) {
    return SleepRangeResponse(
      sleep: (json['sleep'] as List).map((e) => Sleep.fromJson(e)).toList(),
    );
  }
}
