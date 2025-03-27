class SleepLogResponse {
  final List<Sleep> sleep;
  final Summary summary;

  SleepLogResponse({
    required this.sleep,
    required this.summary,
  });

  factory SleepLogResponse.fromJson(Map<String, dynamic> json) {
    return SleepLogResponse(
      sleep: (json['sleep'] as List).map((e) => Sleep.fromJson(e)).toList(),
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Sleep {
  final String dateOfSleep;
  final int duration;
  final int efficiency;
  final DateTime endTime;
  final int infoCode;
  final bool isMainSleep;
  final Levels levels;
  final int logId;
  final int minutesAfterWakeup;
  final int minutesAsleep;
  final int minutesAwake;
  final int minutesToFallAsleep;
  final String logType;
  final DateTime startTime;
  final int timeInBed;
  final String type;

  Sleep({
    required this.dateOfSleep,
    required this.duration,
    required this.efficiency,
    required this.endTime,
    required this.infoCode,
    required this.isMainSleep,
    required this.levels,
    required this.logId,
    required this.minutesAfterWakeup,
    required this.minutesAsleep,
    required this.minutesAwake,
    required this.minutesToFallAsleep,
    required this.logType,
    required this.startTime,
    required this.timeInBed,
    required this.type,
  });

  factory Sleep.fromJson(Map<String, dynamic> json) {
    return Sleep(
      dateOfSleep: json['dateOfSleep'],
      duration: json['duration'],
      efficiency: json['efficiency'],
      endTime: DateTime.parse(json['endTime']),
      infoCode: json['infoCode'],
      isMainSleep: json['isMainSleep'],
      levels: Levels.fromJson(json['levels']),
      logId: json['logId'],
      minutesAfterWakeup: json['minutesAfterWakeup'],
      minutesAsleep: json['minutesAsleep'],
      minutesAwake: json['minutesAwake'],
      minutesToFallAsleep: json['minutesToFallAsleep'],
      logType: json['logType'],
      startTime: DateTime.parse(json['startTime']),
      timeInBed: json['timeInBed'],
      type: json['type'],
    );
  }
}

class Levels {
  final List<LevelData> data;
  final List<LevelData> shortData;
  final LevelSummary summary;

  Levels({
    required this.data,
    required this.shortData,
    required this.summary,
  });

  factory Levels.fromJson(Map<String, dynamic> json) {
    return Levels(
      data: (json['data'] as List).map((e) => LevelData.fromJson(e)).toList(),
      shortData: (json['shortData'] as List).map((e) => LevelData.fromJson(e)).toList(),
      summary: LevelSummary.fromJson(json['summary']),
    );
  }
}

class LevelData {
  final DateTime dateTime;
  final String level;
  final int seconds;

  LevelData({
    required this.dateTime,
    required this.level,
    required this.seconds,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      dateTime: DateTime.parse(json['dateTime']),
      level: json['level'],
      seconds: json['seconds'],
    );
  }
}

class LevelSummary {
  final LevelDetail deep;
  final LevelDetail light;
  final LevelDetail rem;
  final LevelDetail wake;

  LevelSummary({
    required this.deep,
    required this.light,
    required this.rem,
    required this.wake,
  });

  factory LevelSummary.fromJson(Map<String, dynamic> json) {
    return LevelSummary(
      deep: LevelDetail.fromJson(json['deep']),
      light: LevelDetail.fromJson(json['light']),
      rem: LevelDetail.fromJson(json['rem']),
      wake: LevelDetail.fromJson(json['wake']),
    );
  }
}

class LevelDetail {
  final int count;
  final int minutes;
  final int thirtyDayAvgMinutes;

  LevelDetail({
    required this.count,
    required this.minutes,
    required this.thirtyDayAvgMinutes,
  });

  factory LevelDetail.fromJson(Map<String, dynamic> json) {
    return LevelDetail(
      count: json['count'],
      minutes: json['minutes'],
      thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'],
    );
  }
}

class Summary {
  final Stages stages;
  final int totalMinutesAsleep;
  final int totalSleepRecords;
  final int totalTimeInBed;

  Summary({
    required this.stages,
    required this.totalMinutesAsleep,
    required this.totalSleepRecords,
    required this.totalTimeInBed,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      stages: Stages.fromJson(json['stages']),
      totalMinutesAsleep: json['totalMinutesAsleep'],
      totalSleepRecords: json['totalSleepRecords'],
      totalTimeInBed: json['totalTimeInBed'],
    );
  }
}

class Stages {
  final int deep;
  final int light;
  final int rem;
  final int wake;

  Stages({
    required this.deep,
    required this.light,
    required this.rem,
    required this.wake,
  });

  factory Stages.fromJson(Map<String, dynamic> json) {
    return Stages(
      deep: json['deep'],
      light: json['light'],
      rem: json['rem'],
      wake: json['wake'],
    );
  }
}