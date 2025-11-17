import 'package:flutter/material.dart';

/// 睡眠データの形式を表す列挙型
enum SleepType {
  /// stages形式（新しいFitbitデバイス）: deep, light, rem, wake
  stages,

  /// classic形式（古いFitbitデバイス）: asleep, restless, awake
  classic,
}

/// グラフ表示用に変換された睡眠データ
class SleepChartData {
  /// 表示範囲の開始時刻
  final DateTime startTime;

  /// 表示範囲の終了時刻
  final DateTime endTime;

  /// グラフ用ステージセグメントのリスト
  final List<SleepStageSegment> stages;

  /// トータル睡眠時間（分）
  final int totalSleepMinutes;

  /// 睡眠データの形式（stages または classic）
  final SleepType sleepType;

  SleepChartData({
    required this.startTime,
    required this.endTime,
    required this.stages,
    required this.totalSleepMinutes,
    required this.sleepType,
  });

  /// トータル睡眠時間を「X時間Y分」形式でフォーマット
  String get formattedTotalSleep {
    final hours = totalSleepMinutes ~/ 60;
    final minutes = totalSleepMinutes % 60;
    return '$hours時間$minutes分';
  }
}

/// グラフの1つのセグメント（棒）を表す
class SleepStageSegment {
  /// セグメントの開始時刻
  final DateTime startTime;

  /// セグメントの終了時刻
  final DateTime endTime;

  /// ステージタイプ（stages: deep/light/rem/wake、classic: asleep/restless/awake）
  final String stage;

  /// 継続時間（分）
  final double durationMinutes;

  /// 表示色
  final Color color;

  SleepStageSegment({
    required this.startTime,
    required this.endTime,
    required this.stage,
    required this.durationMinutes,
    required this.color,
  });
}
