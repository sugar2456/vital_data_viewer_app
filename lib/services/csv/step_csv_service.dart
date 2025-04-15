import 'package:vital_data_viewer_app/models/response/step_response.dart';

class StepCsvService {
  StepResponse? stepResponse;

  StepCsvService({
    required this.stepResponse,
  });

  StepCsvData convertCsvData() {
    StepCsvData csvData = StepCsvData(
      stepCsvSummary: StepCsvSummary(
        date: '',
        totalSteps: 0,
        interval: 0,
        unit: '',
      ),
      stepDatasets: [],
    );
    if (stepResponse == null) {
      return csvData;
    }

    StepCsvSummary stepCsvData = StepCsvSummary(
      date: stepResponse!.activitiesSteps.first.dateTime.split('T')[0],
      totalSteps: stepResponse!.activitiesSteps.first.value,
      interval: stepResponse!.activitiesStepsIntraday.datasetInterval,
      unit: stepResponse!.activitiesStepsIntraday.datasetType,
    );

    List<StepDataset> stepDatasets = [];
    stepResponse?.activitiesStepsIntraday.dataset.forEach((dataset) {
      DateTime dateTime = dataset.dateTime;
      double value = dataset.value;

      StepDataset stepDataset = StepDataset(
        dateTime: dateTime,
        value: value,
      );
      stepDatasets.add(stepDataset);
    });

    return StepCsvData(
      stepCsvSummary: stepCsvData,
      stepDatasets: stepDatasets,
    );
  }

  List<String> createStepSummaryCsv(StepCsvSummary stepCsvSummary) {
    String header = '"日付,総合歩数,間隔,単位"';
    String summary = '"${stepCsvSummary.date},${stepCsvSummary.totalSteps},${stepCsvSummary.interval},${stepCsvSummary.unit}"';
    return [header, summary];
  }

  List<String> createStepDatasetCsv(List<StepDataset> stepDatasets) {
    String header = '"時間,歩数"';
    List<String> datasetList = [];
    for (var dataset in stepDatasets) {
      String datasetString = '"${dataset.dateTime},${dataset.value}"';
      datasetList.add(datasetString);
    }
    return [header, ...datasetList];
  }
}

/// CSVデータの構造体
class StepCsvData {
  /// CSVのサマリー情報
  StepCsvSummary stepCsvSummary;
  /// CSVのデータセット
  List<StepDataset> stepDatasets;
  StepCsvData({
    required this.stepCsvSummary,
    required this.stepDatasets,
  });
}

class StepCsvSummary {
  String date;
  int totalSteps;
  int interval;
  String unit;

  StepCsvSummary({
    required this.date,
    required this.totalSteps,
    required this.interval,
    required this.unit,
  });
}

class StepDataset {
  DateTime dateTime;
  double value;

  StepDataset({
    required this.dateTime,
    required this.value,
  });
}