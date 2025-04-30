import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/dataset.dart';
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/repositories/impls/swimming_repository_impl.dart';
import 'package:intl/intl.dart';

class SwimmingViewModel extends ChangeNotifier {
  final SwimmingRepositoryImpl _swimmingRepository;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  String get dateLabel => DateFormat('yyyy/MM/dd').format(_date.toLocal());
  SwimmingResponse? _swimmingResponse;
  List<Dataset> get getSwimmingIntraday =>
      _swimmingResponse!.activitiesSwimmingStrokeIntraday.dataset;
  int get getTotalSwimmingStrokes =>
      _swimmingResponse!.activitiesSwimmingStroke[0].value;

  SwimmingViewModel(this._swimmingRepository);

  Future<void> fetchSwimming() async {
    final getDate = _date.toIso8601String().split('T').first;
    _swimmingResponse =
        await _swimmingRepository.fetchSwimming(getDate, '1min');
    notifyListeners();
  }

  Future<void> setSelectedDate(DateTime selectedDate) async {
    final getDate = selectedDate.toIso8601String().split('T').first;
    _date = selectedDate;
    _swimmingResponse =
        await _swimmingRepository.fetchSwimming(getDate, '1min');
    notifyListeners();
  }
}
