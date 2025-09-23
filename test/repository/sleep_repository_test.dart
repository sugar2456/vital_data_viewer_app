import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/const/response_type.dart';
import 'package:vital_data_viewer_app/repositories/impls/sleep_repository_impl.dart';

void main() {
  group('SleepRepositoryImpl', () {
    late MockClient mockClient;
    late SleepRepositoryImpl sleepRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
              '{"goal": {"minDuration": 480, "updatedOn": "2023-01-19"}}', 200);
        },
      );
      sleepRepository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });
    test('fetchSleepGoal returns SleepGoalResponse when API call is successful',
        () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');
      const mockResponse = '''
{
  "consistency": {
    "flowId": 2
  },
  "goal": {
    "minDuration": 480,
    "updatedOn": "2020-01-01T13:00:00.126Z"
  }
}
      ''';

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response(mockResponse, 200);
        }
        return http.Response('Not Found', 404);
      });

      sleepRepository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await sleepRepository.fetchSleepGoal();

      // Assert
      expect(response.sleepConsistency?.flowId, SleepConsistency.notSetGoalNotSleepRecorded);
      expect(response.goal.minDuration, 480);
      expect(response.goal.updatedOn.toIso8601String(),
          '2020-01-01T13:00:00.126Z');
    });

    test('fetchSleepLog returns SleepLogResponse when API call is successful',
        () async {
      // Arrange
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final uri =
          Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');
      const mockResponse = '''
{
    "sleep": [
        {
            "dateOfSleep": "2020-02-21",
            "duration": 27720000,
            "efficiency": 96,
            "endTime": "2020-02-21T07:03:30.000",
            "infoCode": 0,
            "isMainSleep": true,
            "levels": {
                "data": [
                    {
                        "dateTime": "2020-02-20T23:21:30.000",
                        "level": "wake",
                        "seconds": 630
                    },
                    {
                        "dateTime": "2020-02-20T23:32:00.000",
                        "level": "light",
                        "seconds": 30
                    },
                    {
                        "dateTime": "2020-02-20T23:32:30.000",
                        "level": "deep",
                        "seconds": 870
                    },
                    {
                        "dateTime": "2020-02-21T06:32:30.000",
                        "level": "light",
                        "seconds": 1860
                    }
                ],
                "shortData": [
                    {
                        "dateTime": "2020-02-21T00:10:30.000",
                        "level": "wake",
                        "seconds": 30
                    },
                    {
                        "dateTime": "2020-02-21T00:15:00.000",
                        "level": "wake",
                        "seconds": 30
                    },
                    {
                        "dateTime": "2020-02-21T06:18:00.000",
                        "level": "wake",
                        "seconds": 60
                    }
                ],
                "summary": {
                    "deep": {
                        "count": 5,
                        "minutes": 104,
                        "thirtyDayAvgMinutes": 69
                    },
                    "light": {
                        "count": 32,
                        "minutes": 205,
                        "thirtyDayAvgMinutes": 202
                    },
                    "rem": {
                        "count": 11,
                        "minutes": 75,
                        "thirtyDayAvgMinutes": 87
                    },
                    "wake": {
                        "count": 30,
                        "minutes": 78,
                        "thirtyDayAvgMinutes": 55
                    }
                }
            },
            "logId": 26013218219,
            "minutesAfterWakeup": 0,
            "minutesAsleep": 384,
            "minutesAwake": 78,
            "minutesToFallAsleep": 0,
            "logType": "auto_detected",
            "startTime": "2020-02-20T23:21:30.000",
            "timeInBed": 462,
            "type": "stages"
        }
    ],
    "summary": {
        "stages": {
            "deep": 104,
            "light": 205,
            "rem": 75,
            "wake": 78
        },
        "totalMinutesAsleep": 384,
        "totalSleepRecords": 1,
        "totalTimeInBed": 462
    }
}
      ''';

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response(mockResponse, 200);
        }
        return http.Response('Not Found', 404);
      });

      sleepRepository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await sleepRepository.fetchSleepLog();

      // Assert
      expect(response.sleep[0].dateOfSleep, '2020-02-21');
      expect(response.sleep[0].duration, 27720000);
      expect(response.sleep[0].efficiency, 96);
      expect(response.sleep[0].isMainSleep, true);
      expect(response.sleep[0].logId, 26013218219);
      expect(response.sleep[0].minutesAfterWakeup, 0);
      expect(response.sleep[0].minutesAsleep, 384);
      expect(response.sleep[0].minutesAwake, 78);
      expect(response.sleep[0].minutesToFallAsleep, 0);
      expect(response.sleep[0].logType, 'auto_detected');
      expect(response.sleep[0].startTime, DateTime.parse('2020-02-20T23:21:30.000'));
      expect(response.sleep[0].timeInBed, 462);
      expect(response.sleep[0].type, 'stages');
      expect(
          response.sleep[0].levels.data[0].dateTime, DateTime.parse('2020-02-20T23:21:30.000'));
      expect(response.sleep[0].levels.data[0].level, 'wake');
      expect(response.sleep[0].levels.data[0].seconds, 630);
      expect(response.sleep[0].levels.shortData[0].dateTime,
          DateTime.parse('2020-02-21T00:10:30.000'));
      expect(response.sleep[0].levels.shortData[0].level, 'wake');
      expect(response.sleep[0].levels.shortData[0].seconds, 30);
      expect(response.sleep[0].levels.summary.deep.count, 5);
      expect(response.sleep[0].levels.summary.deep.minutes, 104);
      expect(response.sleep[0].levels.summary.deep.thirtyDayAvgMinutes, 69);
      expect(response.sleep[0].levels.summary.light.count, 32);
      expect(response.sleep[0].levels.summary.light.minutes, 205);
      expect(response.sleep[0].levels.summary.light.thirtyDayAvgMinutes, 202);
      expect(response.sleep[0].levels.summary.rem.count, 11);
      expect(response.sleep[0].levels.summary.rem.minutes, 75);
      expect(response.sleep[0].levels.summary.rem.thirtyDayAvgMinutes, 87);
      expect(response.sleep[0].levels.summary.wake.count, 30);
      expect(response.sleep[0].levels.summary.wake.minutes, 78);
      expect(response.sleep[0].levels.summary.wake.thirtyDayAvgMinutes, 55);
    });

    test('fetchSleepGoal throws Exception when API call fails', () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1.2/user/-/sleep/goal.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      sleepRepository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await sleepRepository.fetchSleepGoal(),
        throwsException,
      );
    });

    test('fetchSleepLog throws Exception when API call fails', () async {
      // Arrange
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final uri =
          Uri.https('api.fitbit.com', '/1.2/user/-/sleep/date/$date.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      sleepRepository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await sleepRepository.fetchSleepLog(),
        throwsException,
      );
    });
  });
}
