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