import 'package:vital_data_viewer_app/models/response/dataset.dart';
import 'package:vital_data_viewer_app/util/convert_util.dart';

class CaloriesDataset extends Dataset {
  final int? mets;
  final int? level;

  CaloriesDataset({
    required super.time,
    required super.value,
    required super.dateTime,
    this.mets,
    this.level,
  });

  factory CaloriesDataset.fromJson(Map<String, dynamic> json, String baseDate) {
    final fullDateTimeString = '$baseDate ${json['time'] ?? ''}';
    return CaloriesDataset(
      time: json['time'] ?? '',
      value: ConvertUtil.roundToOneDecimalPlaces(json['value']),
      dateTime: DateTime.parse(fullDateTimeString),
      mets: json['mets'],
      level: json['level'],
    );
  }
}