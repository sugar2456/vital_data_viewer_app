enum GoalTyle {
  lose,
  gain,
  maintain
}

extension GoalTyleExtension on GoalTyle {
  static GoalTyle fromString(String value) {
    switch (value) {
      case 'LOSE':
        return GoalTyle.lose;
      case 'GAIN':
        return GoalTyle.gain;
      case 'MAINTAIN':
        return GoalTyle.maintain;
      default:
        throw ArgumentError('Invalid goalType: $value');
    }
  }
}

enum DeviceBattery {
  low,
  medium,
  high,
  empty,
}

extension DeviceButteryExtension on DeviceBattery {
  static DeviceBattery fromString(String value) {
    switch (value) {
      case 'Low':
        return DeviceBattery.low;
      case 'Medium':
        return DeviceBattery.medium;
      case 'High':
        return DeviceBattery.high;
      case 'Empty':
        return DeviceBattery.empty;
      default:
        throw ArgumentError('Invalid battery: $value');
    }
  }
}

enum DeviceType {
  tracker,
  scale,
}

extension DeviceTypeExtension on DeviceType {
  static DeviceType fromString(String value) {
    switch (value) {
      case 'TRACKER':
        return DeviceType.tracker;
      case 'SCALE':
        return DeviceType.scale;
      default:
        throw ArgumentError('Invalid deviceType: $value');
    }
  }
}

enum SleepConsistency {
  setGoalNotSleepRecorded,
  notSetGoalButSleepRecorded,
  notSetGoalNotSleepRecorded,
  setGoalAndSleepRecorded,
}