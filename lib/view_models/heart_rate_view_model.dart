import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:intl/intl.dart';
class HeartRateViewModel extends ChangeNotifier {
  final HeartRateRepositoryInterdace _heartRateRepository;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  String get dateLabel => DateFormat('yyyy/MM/dd').format(_date.toLocal());
  HeartRateResponse? _heartRateResponse;

  List<dynamic> get getHeartRateIntraday =>
      _heartRateResponse!.activitiesHeartRateIntraday.dataset;

  HeartRateViewModel(this._heartRateRepository);

  Future<void> fetchHeartRate() async {
    final getDate = _date.toIso8601String().split('T').first;
    _heartRateResponse =
        await _heartRateRepository.fetchHeartRate(getDate, '1min');
    notifyListeners();
  }

  Future<void> setSelectedDate(DateTime selectedDate) async {
    final getDate = selectedDate.toIso8601String().split('T').first;
    _date = selectedDate;
    _heartRateResponse =
        await _heartRateRepository.fetchHeartRate(getDate, '1min');
    notifyListeners();
  }
}
