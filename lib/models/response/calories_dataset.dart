import 'package:vital_data_viewer_app/models/response/dataset.dart';

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
      value: json['value'] ?? 0,
      dateTime: DateTime.parse(fullDateTimeString),
      mets: json['mets'],
      level: json['level'],
    );
  }
}