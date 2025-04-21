import 'package:vital_data_viewer_app/models/response/swimming_response.dart';

class SwimmingCsvService {
  /// SwimmingResponseからCSVデータに変換する
  static SwimmingCsvData convertCsvData(SwimmingResponse? swimmingResponse) {
    SwimmingCsvData csvData = SwimmingCsvData(
      swimmingCsvSummary: SwimmingCsvSummary(
        date: '',
        totalStrokes: 0,
        interval: 0,
        unit: '',
      ),
      swimmingDatasets: [],
    );
    if (swimmingResponse == null) {
      return csvData;
    }

    SwimmingCsvSummary swimmingCsvSummary = SwimmingCsvSummary(
      date: swimmingResponse.activitiesSwimmingStroke.first.dateTime.split('T')[0],
      totalStrokes: swimmingResponse.activitiesSwimmingStroke.first.value,
      interval: swimmingResponse.activitiesSwimmingStrokeIntraday.datasetInterval,
      unit: swimmingResponse.activitiesSwimmingStrokeIntraday.datasetType,
    );

    List<SwimmingDataset> swimmingDatasets = [];
    for (var dataset in swimmingResponse.activitiesSwimmingStrokeIntraday.dataset) {
      DateTime dateTime = dataset.dateTime;
      double value = dataset.value;

      SwimmingDataset swimmingDataset = SwimmingDataset(
        dateTime: dateTime,
        value: value,
      );
      swimmingDatasets.add(swimmingDataset);
    }

    return SwimmingCsvData(
      swimmingCsvSummary: swimmingCsvSummary,
      swimmingDatasets: swimmingDatasets,
    );
  }

  /// サマリー情報からCSV行を生成する
  static List<String> createSwimmingSummaryCsv(SwimmingCsvSummary swimmingCsvSummary) {
    String header = '"日付,総合ストローク数,間隔,単位"';
    String summary = '"${swimmingCsvSummary.date},${swimmingCsvSummary.totalStrokes},${swimmingCsvSummary.interval},${swimmingCsvSummary.unit}"';
    return [header, summary];
  }

  /// データセットからCSV行を生成する
  static List<String> createSwimmingDatasetCsv(List<SwimmingDataset> swimmingDatasets) {
    String header = '"時間,ストローク数"';
    List<String> datasetList = [];
    for (var dataset in swimmingDatasets) {
      String datasetString = '"${dataset.dateTime},${dataset.value}"';
      datasetList.add(datasetString);
    }
    return [header, ...datasetList];
  }
}

/// CSVデータの構造体
class SwimmingCsvData {
  /// CSVのサマリー情報
  SwimmingCsvSummary swimmingCsvSummary;
  /// CSVのデータセット
  List<SwimmingDataset> swimmingDatasets;
  SwimmingCsvData({
    required this.swimmingCsvSummary,
    required this.swimmingDatasets,
  });
}

class SwimmingCsvSummary {
  String date;
  int totalStrokes;
  int interval;
  String unit;

  SwimmingCsvSummary({
    required this.date,
    required this.totalStrokes,
    required this.interval,
    required this.unit,
  });
}

class SwimmingDataset {
  DateTime dateTime;
  double value;

  SwimmingDataset({
    required this.dateTime,
    required this.value,
  });
}