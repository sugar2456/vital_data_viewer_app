import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/calories_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';

// 他の必要なimport

class CsvService {
  final StepRepositoryInterface _stepRepository;
  final HeartRateRepositoryInterdace _heartRateRepository;
  final SleepRepositoryInterface _sleepRepository;
  final CaloriesRepositoryInterdace _caloriesRepository;
  final SwimmingRepositoryInterface _swimmingRepository;

  CsvService({
    required StepRepositoryInterface stepRepository,
    required HeartRateRepositoryInterdace heartRateRepository,
    required SleepRepositoryInterface sleepRepository,
    required CaloriesRepositoryInterdace caloriesRepository,
    required SwimmingRepositoryInterface swimmingRepository,
  })  : _stepRepository = stepRepository,
        _heartRateRepository = heartRateRepository,
        _sleepRepository = sleepRepository,
        _caloriesRepository = caloriesRepository,
        _swimmingRepository = swimmingRepository;

  Future<List<String>> exportCsvData(
      List<String> dataTypes, DateTime selectedDate) async {
    final results = <String>[];

    for (final dataType in dataTypes) {
      switch (dataType) {
        case 'steps':
          final stepData = await _stepRepository.fetchStep(
              selectedDate.toIso8601String().split('T')[0], '1min');
          break;
        case 'heartrate':
          final heartRateData = await _heartRateRepository.fetchHeartRate(
              selectedDate.toIso8601String().split('T')[0], '1min');
          break;
        case 'calories':
          final caloriesData = await _caloriesRepository.fetchCalories(
              selectedDate.toIso8601String().split('T')[0], '1min');
          break;
        case 'swimming':
          final swimmingData = await _swimmingRepository.fetchSwimming(
              selectedDate.toIso8601String().split('T')[0], '1min');
          break;
        case 'sleep':
          final sleepData = await _sleepRepository.fetchSleepLog();
          break;
      }
    }

    return results;
  }
}
