import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';

class HeartRateViewModel extends ChangeNotifier {
  final HeartRateRepositoryInterdace _heartRateRepository;
  final DateTime date = DateTime.now();
  HeartRateResponse? _heartRateResponse;

  List<dynamic> get getHeartRateIntraday => _heartRateResponse!.activitiesHeartRateIntraday.dataset;

  HeartRateViewModel(this._heartRateRepository);

  Future<void> fetchHeartRate() async {
    try {
      final getDate = date.toIso8601String().split('T').first;
      _heartRateResponse = await _heartRateRepository.fetchHeartRate(getDate, '1min');
    } catch (e) {
      debugPrint('心拍数情報の取得に失敗しました。$e');
    }
  }
}