import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/view_models/sleep_chart_data.dart';
import 'package:intl/intl.dart';

/// 睡眠データ表示画面の状態管理を行うViewModel
class SleepViewModel extends ChangeNotifier {
  final SleepRepositoryInterface _repository;

  SleepViewModel({required SleepRepositoryInterface repository})
      : _repository = repository;

  // 状態
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  SleepChartData? _sleepChartData;
  SleepChartData? get sleepChartData => _sleepChartData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasData => _sleepChartData != null;

  /// 今日の睡眠データを取得する（初期化用）
  Future<void> fetchTodaySleepData() async {
    await fetchSleepData(DateTime.now());
  }

  /// 指定された日付の睡眠データを取得する
  Future<void> fetchSleepData(DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedDate = date;
    notifyListeners();

    try {
      // 日付をYYYY-MM-DD形式に変換
      final dateString = DateFormat('yyyy-MM-dd').format(date);

      // Repositoryから睡眠データを取得
      final response = await _repository.fetchSleepLogByDate(dateString);

      // データが空の場合
      if (response.sleep.isEmpty) {
        _sleepChartData = null;
        _errorMessage = '選択した日付の睡眠データがありません';
      } else {
        // メインの睡眠セッションを取得（複数ある場合は最初のメインセッション）
        final mainSleep = response.sleep.firstWhere(
          (s) => s.isMainSleep,
          orElse: () => response.sleep.first,
        );

        // グラフ用データに変換
        _sleepChartData = _convertToChartData(mainSleep);
      }
    } catch (e) {
      _sleepChartData = null;
      _errorMessage = '睡眠データの取得中にエラーが発生しました: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// SleepLogResponseをSleepChartDataに変換する
  SleepChartData _convertToChartData(Sleep sleep) {
    // 睡眠タイプを判定（stages または classic）
    final sleepType =
        sleep.type == 'stages' ? SleepType.stages : SleepType.classic;

    // ステージセグメントのリストを作成
    final segments = <SleepStageSegment>[];

    for (final levelData in sleep.levels.data) {
      final startTime = levelData.dateTime;
      final durationMinutes = levelData.seconds / 60.0;
      final endTime = startTime.add(Duration(seconds: levelData.seconds));
      final color = _getStageColor(levelData.level, sleepType);

      segments.add(SleepStageSegment(
        startTime: startTime,
        endTime: endTime,
        stage: levelData.level,
        durationMinutes: durationMinutes,
        color: color,
      ));
    }

    return SleepChartData(
      startTime: sleep.startTime,
      endTime: sleep.endTime,
      stages: segments,
      totalSleepMinutes: sleep.minutesAsleep,
      sleepType: sleepType,
    );
  }

  /// 睡眠ステージに応じた色を返す
  Color _getStageColor(String stage, SleepType sleepType) {
    if (sleepType == SleepType.stages) {
      // stages形式の色マッピング
      switch (stage) {
        case 'deep':
          return Colors.blue[900]!;
        case 'light':
          return Colors.blue[300]!;
        case 'rem':
          return Colors.purple;
        case 'wake':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    } else {
      // classic形式の色マッピング
      switch (stage) {
        case 'asleep':
          return Colors.blue;
        case 'restless':
          return Colors.yellow;
        case 'awake':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
  }
}
