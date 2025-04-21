import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';

class SleepCsvService {
  /// SleepLogResponseからCSVデータに変換する
  static SleepCsvData convertCsvData(SleepLogResponse? sleepLogResponse) {
    SleepCsvData csvData = SleepCsvData(
      sleepCsvSummary: SleepCsvSummary(
        date: '',
        totalMinutesAsleep: 0,
        totalTimeInBed: 0,
        sleepEfficiency: 0,
      ),
      sleepDatasets: [],
    );
    if (sleepLogResponse == null) {
      return csvData;
    }

    // サマリー情報を設定
    // 最新の睡眠データを取得（通常は1日に複数の睡眠データが記録される可能性があるため）
    final mainSleep = sleepLogResponse.sleep.isNotEmpty 
        ? sleepLogResponse.sleep.firstWhere(
            (sleep) => sleep.isMainSleep, 
            orElse: () => sleepLogResponse.sleep.first)
        : null;
    
    if (mainSleep != null) {
      SleepCsvSummary sleepCsvSummary = SleepCsvSummary(
        date: mainSleep.dateOfSleep,
        totalMinutesAsleep: mainSleep.minutesAsleep,
        totalTimeInBed: mainSleep.timeInBed,
        sleepEfficiency: mainSleep.efficiency,
      );

      // 睡眠の段階データを変換
      List<SleepDataset> sleepDatasets = [];
      for (var levelData in mainSleep.levels.data) {
        SleepDataset sleepDataset = SleepDataset(
          dateTime: levelData.dateTime,
          level: levelData.level,
          seconds: levelData.seconds,
        );
        sleepDatasets.add(sleepDataset);
      }

      return SleepCsvData(
        sleepCsvSummary: sleepCsvSummary,
        sleepDatasets: sleepDatasets,
      );
    }

    return csvData;
  }

  /// サマリー情報からCSV行を生成する
  static List<String> createSleepSummaryCsv(SleepCsvSummary sleepCsvSummary) {
    String header = '日付,睡眠時間(分),ベッドでの時間(分),睡眠効率(%)';
    String summary = '${sleepCsvSummary.date},${sleepCsvSummary.totalMinutesAsleep},${sleepCsvSummary.totalTimeInBed},${sleepCsvSummary.sleepEfficiency}';
    return [header, summary];
  }

  /// データセットからCSV行を生成する
  static List<String> createSleepDatasetCsv(List<SleepDataset> sleepDatasets) {
    String header = '時間,睡眠レベル,継続時間(秒)';
    List<String> datasetList = [];
    for (var dataset in sleepDatasets) {
      String datasetString = '${dataset.dateTime},${dataset.level},${dataset.seconds}';
      datasetList.add(datasetString);
    }
    return [header, ...datasetList];
  }
}

/// CSVデータの構造体
class SleepCsvData {
  /// CSVのサマリー情報
  SleepCsvSummary sleepCsvSummary;
  /// CSVのデータセット
  List<SleepDataset> sleepDatasets;
  SleepCsvData({
    required this.sleepCsvSummary,
    required this.sleepDatasets,
  });
}

class SleepCsvSummary {
  String date;
  int totalMinutesAsleep;
  int totalTimeInBed;
  int sleepEfficiency;

  SleepCsvSummary({
    required this.date,
    required this.totalMinutesAsleep,
    required this.totalTimeInBed,
    required this.sleepEfficiency,
  });
}

class SleepDataset {
  DateTime dateTime;
  String level;
  int seconds;

  SleepDataset({
    required this.dateTime,
    required this.level,
    required this.seconds,
  });
}