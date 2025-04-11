import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/repositories/impls/activity_repository_impl.dart';

void main() {
  group('ActivityRepositoryImpl', () {
    late MockClient mockClient;
    late ActivityRepositoryImpl activityRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
            '''
{
  "goals": {
    "caloriesOut": 2200,
    "activeMinutes": 30,
    "steps": 10000,
    "distance": 8.05
  }
}
            ''',
            200,
          );
        },
      );
      activityRepository = ActivityRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchActivityGoal returns AcitivityGoalResponse when API call is successful', () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/goals/daily.json');
      const mockResponse = '''
{
    "goals": {
        "activeMinutes": 55,
        "activeZoneMinutes": 21,
        "caloriesOut": 3500,
        "distance": 5.0,
        "floors": 10,
        "steps": 10000
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

      activityRepository = ActivityRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await activityRepository.fetchActivityGoal();

      // Assert
      expect(response.steps, 10000);
      expect(response.caloriesOut, 3500);
      expect(response.activeMinutes, 55);
      expect(response.distance, 5);
      expect(response.activeMinutes, 55);
      expect(response.activeZoneMinutes, 21);
    });

    test('fetchActivitySummary returns ActivitySummaryResponse when API call is successful', () async {
      // Arrange
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/date/$date.json');
      const mockResponse = '''
{
  "activities": [],
  "goals": {
    "activeMinutes": 30,
    "caloriesOut": 1950,
    "distance": 8.05,
    "floors": 10,
    "steps": 6800
  },
  "summary": {
    "activeScore": -1,
    "activityCalories": 525,
    "calorieEstimationMu": 2241,
    "caloriesBMR": 1973,
    "caloriesOut": 2628,
    "caloriesOutUnestimated": 2628,
    "customHeartRateZones": [
      {
        "caloriesOut": 2616.7788,
        "max": 140,
        "min": 30,
        "minutes": 1432,
        "name": "Below"
      },
      {
        "caloriesOut": 0,
        "max": 165,
        "min": 140,
        "minutes": 0,
        "name": "Custom Zone"
      },
      {
        "caloriesOut": 0,
        "max": 220,
        "min": 165,
        "minutes": 0,
        "name": "Above"
      }
    ],
    "distances": [
      {
        "activity": "total",
        "distance": 1.26
      },
      {
        "activity": "tracker",
        "distance": 1.26
      },
      {
        "activity": "loggedActivities",
        "distance": 0
      },
      {
        "activity": "veryActive",
        "distance": 0
      },
      {
        "activity": "moderatelyActive",
        "distance": 0
      },
      {
        "activity": "lightlyActive",
        "distance": 1.25
      },
      {
        "activity": "sedentaryActive",
        "distance": 0
      }
    ],
    "elevation": 0,
    "fairlyActiveMinutes": 0,
    "floors": 0,
    "heartRateZones": [
      {
        "caloriesOut": 1200.33336,
        "max": 86,
        "min": 30,
        "minutes": 812,
        "name": "Out of Range"
      },
      {
        "caloriesOut": 1409.4564,
        "max": 121,
        "min": 86,
        "minutes": 619,
        "name": "Fat Burn"
      },
      {
        "caloriesOut": 6.98904,
        "max": 147,
        "min": 121,
        "minutes": 1,
        "name": "Cardio"
      },
      {
        "caloriesOut": 0,
        "max": 220,
        "min": 147,
        "minutes": 0,
        "name": "Peak"
      }
    ],
    "lightlyActiveMinutes": 110,
    "marginalCalories": 281,
    "restingHeartRate": 77,
    "sedentaryMinutes": 802,
    "steps": 1698,
    "useEstimation": true,
    "veryActiveMinutes": 0
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

      activityRepository = ActivityRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await activityRepository.fetchActivitySummary();

      // Assert
      expect(response.goals.activeMinutes, 30);
      expect(response.goals.caloriesOut, 1950);
      expect(response.goals.distance, 8.05);
      expect(response.goals.steps, 6800);
      expect(response.summary.activeScore, -1);
      expect(response.summary.activityCalories, 525);
      expect(response.summary.calorieEstimationMu, 2241);
      expect(response.summary.caloriesBMR, 1973);
      expect(response.summary.caloriesOut, 2628);
      expect(response.summary.caloriesOutUnestimated, 2628);
      expect(response.summary.customHeartRateZones[0].caloriesOut, 2616.7788);
      expect(response.summary.customHeartRateZones[0].max, 140);
      expect(response.summary.customHeartRateZones[0].min, 30);
      expect(response.summary.customHeartRateZones[0].minutes, 1432);
      expect(response.summary.customHeartRateZones[0].name, 'Below');
      expect(response.summary.distances[0].activity, 'total');
      expect(response.summary.distances[0].distance, 1.26);
      expect(response.summary.elevation, 0);
      expect(response.summary.fairlyActiveMinutes, 0);
      expect(response.summary.floors, 0);
      expect(response.summary.heartRateZones[0].caloriesOut, 1200.33336);
      expect(response.summary.heartRateZones[0].max, 86);
      expect(response.summary.heartRateZones[0].min, 30);
      expect(response.summary.heartRateZones[0].minutes, 812);
      expect(response.summary.heartRateZones[0].name, 'Out of Range');
      expect(response.summary.lightlyActiveMinutes, 110);
      expect(response.summary.marginalCalories, 281);
      expect(response.summary.restingHeartRate, 77);
      expect(response.summary.sedentaryMinutes, 802);
      expect(response.summary.steps, 1698);
      expect(response.summary.useEstimation, true);
      expect(response.summary.veryActiveMinutes, 0);
    });

    test('fetchActivityGoal throws Exception when API call fails', () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/goals/daily.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      activityRepository = ActivityRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await activityRepository.fetchActivityGoal(),
        throwsException,
      );
    });

    test('fetchActivitySummary throws Exception when API call fails', () async {
      // Arrange
      final date = DateTime.now().toIso8601String().substring(0, 10);
      final uri = Uri.https('api.fitbit.com', '/1/user/-/activities/date/$date.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      activityRepository = ActivityRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await activityRepository.fetchActivitySummary(),
        throwsException,
      );
    });
  });
}