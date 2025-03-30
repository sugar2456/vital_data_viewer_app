import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/dataset.dart';
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/repositories/impls/swimming_repository_impl.dart';

class SwimmingViewModel extends ChangeNotifier {
  final SwimmingRepositoryImpl _swimmingRepository;
  final DateTime date = DateTime.now();
  SwimmingResponse? _swimmingResponse;
  List<Dataset> get getSwimmingIntraday => _swimmingResponse!.activitiesSwimmingStrokeIntraday.dataset;
  int get getTotalSwimmingStrokes => _swimmingResponse!.activitiesSwimmingStroke[0].value;

  SwimmingViewModel(this._swimmingRepository);

  Future<void> fetchSwimming() async {
    try {
      final getDate = date.toIso8601String().split('T').first;
      _swimmingResponse = await _swimmingRepository.fetchSwimming(getDate, '1min');
    } catch (e) {
      log('水泳情報の取得に失敗しました。$e');
    }
  }
}