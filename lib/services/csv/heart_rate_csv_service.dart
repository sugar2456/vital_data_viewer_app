import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';

class HeartRateCsvService {
  /// HeartRateResponseからCSVデータに変換する
  static HeartRateCsvData convertCsvData(HeartRateResponse? heartRateResponse) {
    HeartRateCsvData csvData = HeartRateCsvData(
      heartRateCsvSummary: HeartRateCsvSummary(
        date: '',
        averageHeartRate: 0,
        interval: 0,
        unit: '',
      ),
      heartRateDatasets: [],
    );
    if (heartRateResponse == null) {
      return csvData;
    }

    HeartRateCsvSummary heartRateCsvSummary = HeartRateCsvSummary(
      date: heartRateResponse.activitiesHeartRate.first.dateTime,
      averageHeartRate: heartRateResponse.activitiesHeartRate.first.value.restingHeartRate,
      interval: heartRateResponse.activitiesHeartRateIntraday.datasetInterval,
      unit: heartRateResponse.activitiesHeartRateIntraday.datasetType,
    );

    List<HeartRateDataset> heartRateDatasets = [];
    for (var dataset in heartRateResponse.activitiesHeartRateIntraday.dataset) {
      DateTime dateTime = dataset.dateTime;
      double value = dataset.value;

      HeartRateDataset heartRateDataset = HeartRateDataset(
        dateTime: dateTime,
        value: value,
      );
      heartRateDatasets.add(heartRateDataset);
    }

    return HeartRateCsvData(
      heartRateCsvSummary: heartRateCsvSummary,
      heartRateDatasets: heartRateDatasets,
    );
  }

  /// サマリー情報からCSV行を生成する
  static List<String> createHeartRateSummaryCsv(HeartRateCsvSummary heartRateCsvSummary) {
    String header = '"日付,平均心拍数,間隔,単位"';
    String summary = '"${heartRateCsvSummary.date},${heartRateCsvSummary.averageHeartRate},${heartRateCsvSummary.interval},${heartRateCsvSummary.unit}"';
    return [header, summary];
  }

  /// データセットからCSV行を生成する
  static List<String> createHeartRateDatasetCsv(List<HeartRateDataset> heartRateDatasets) {
    String header = '"時間,心拍数"';
    List<String> datasetList = [];
    for (var dataset in heartRateDatasets) {
      String datasetString = '"${dataset.dateTime},${dataset.value}"';
      datasetList.add(datasetString);
    }
    return [header, ...datasetList];
  }
}

/// CSVデータの構造体
class HeartRateCsvData {
  /// CSVのサマリー情報
  HeartRateCsvSummary heartRateCsvSummary;
  /// CSVのデータセット
  List<HeartRateDataset> heartRateDatasets;
  HeartRateCsvData({
    required this.heartRateCsvSummary,
    required this.heartRateDatasets,
  });
}

class HeartRateCsvSummary {
  String date;
  int averageHeartRate;
  int interval;
  String unit;

  HeartRateCsvSummary({
    required this.date,
    required this.averageHeartRate,
    required this.interval,
    required this.unit,
  });
}

class HeartRateDataset {
  DateTime dateTime;
  double value;

  HeartRateDataset({
    required this.dateTime,
    required this.value,
  });
}