class Dataset {
  final String time;
  final double value;
  final DateTime dateTime;

  Dataset({
    required this.time,
    required this.value,
    required this.dateTime,
  });

  factory Dataset.fromJson(Map<String, dynamic> json, String baseDate) {
     // yyyy-MM-dd hh:mm:ss
    final fullDateTimeString = '$baseDate ${json['time']}';
    return Dataset(
      time: json['time'],
      value: (json['value'] as num).toDouble(),
      dateTime: DateTime.parse(fullDateTimeString),
    );
  }
}