import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';

/// 期間指定心拍数APIのレスポンスモデル
/// GET /1/user/-/activities/heart/date/{start}/{end}.json
class HeartRateRangeResponse {
  final List<ActivityHeartRate> activitiesHeart;

  HeartRateRangeResponse({
    required this.activitiesHeart,
  });

  factory HeartRateRangeResponse.fromJson(Map<String, dynamic> json) {
    return HeartRateRangeResponse(
      activitiesHeart: (json['activities-heart'] as List)
          .map((item) => ActivityHeartRate.fromJson(item))
          .toList(),
    );
  }
}
