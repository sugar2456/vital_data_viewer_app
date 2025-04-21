import 'package:vital_data_viewer_app/models/response/calories_response.dart';

class CaloriesCsvService {
  /// CaloriesResponseからCSVデータに変換する
  static CaloriesCsvData convertCsvData(CaloriesResponse? caloriesResponse) {
    CaloriesCsvData csvData = CaloriesCsvData(
      caloriesCsvSummary: CaloriesCsvSummary(
        date: '',
        totalCalories: 0,
        interval: 0,
        unit: '',
      ),
      caloriesDatasets: [],
    );
    if (caloriesResponse == null) {
      return csvData;
    }

    CaloriesCsvSummary caloriesCsvSummary = CaloriesCsvSummary(
      date: caloriesResponse.activitiesCalories.first.dateTime.split('T')[0],
      totalCalories: caloriesResponse.activitiesCalories.first.value,
      interval: caloriesResponse.activitiesCaloriesIntraday.datasetInterval,
      unit: caloriesResponse.activitiesCaloriesIntraday.datasetType,
    );

    List<CaloriesDataset> caloriesDatasets = [];
    for (var dataset in caloriesResponse.activitiesCaloriesIntraday.dataset) {
      DateTime dateTime = dataset.dateTime;
      double value = dataset.value;

      CaloriesDataset caloriesDataset = CaloriesDataset(
        dateTime: dateTime,
        value: value,
      );
      caloriesDatasets.add(caloriesDataset);
    }

    return CaloriesCsvData(
      caloriesCsvSummary: caloriesCsvSummary,
      caloriesDatasets: caloriesDatasets,
    );
  }

  /// サマリー情報からCSV行を生成する
  static List<String> createCaloriesSummaryCsv(CaloriesCsvSummary caloriesCsvSummary) {
    String header = '日付,総合消費カロリー,間隔,単位';
    String summary = '${caloriesCsvSummary.date},${caloriesCsvSummary.totalCalories},${caloriesCsvSummary.interval},${caloriesCsvSummary.unit}';
    return [header, summary];
  }

  /// データセットからCSV行を生成する
  static List<String> createCaloriesDatasetCsv(List<CaloriesDataset> caloriesDatasets) {
    String header = '時間,消費カロリー';
    List<String> datasetList = [];
    for (var dataset in caloriesDatasets) {
      String datasetString = '${dataset.dateTime},${dataset.value}';
      datasetList.add(datasetString);
    }
    return [header, ...datasetList];
  }
}

/// CSVデータの構造体
class CaloriesCsvData {
  /// CSVのサマリー情報
  CaloriesCsvSummary caloriesCsvSummary;
  /// CSVのデータセット
  List<CaloriesDataset> caloriesDatasets;
  CaloriesCsvData({
    required this.caloriesCsvSummary,
    required this.caloriesDatasets,
  });
}

class CaloriesCsvSummary {
  String date;
  double totalCalories;
  int interval;
  String unit;

  CaloriesCsvSummary({
    required this.date,
    required this.totalCalories,
    required this.interval,
    required this.unit,
  });
}

class CaloriesDataset {
  DateTime dateTime;
  double value;

  CaloriesDataset({
    required this.dateTime,
    required this.value,
  });
}
