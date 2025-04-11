import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/const/response_type.dart';
import 'package:vital_data_viewer_app/repositories/impls/body_goal_repository_impl.dart';

void main() {
  group('BodyGoalRepositoryImpl', () {
    late MockClient mockClient;
    late BodyGoalRepositoryImpl bodyGoalRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
            '''
{
  "goal": {
    "weight": 70.0,
    "weightThreshold": 20.0,
    "goalType": "MAINTAIN",
    "startDate": "2023-01-19T12:34:56.789",
    "startWeight": 70.0
  }
}
            ''',
            200,
          );
        },
      );
      bodyGoalRepository = BodyGoalRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchBodyGoal returns BodyGoalResponse when API call is successful',
        () async {
      // Arrange
      final uri =
          Uri.https('api.fitbit.com', '/1/user/-/body/log/weight/goal.json');
      const mockResponse = '''
{
  "goal": {
    "weight": 70.0,
    "weightThreshold": 20.0,
    "goalType": "MAINTAIN",
    "startDate": "2023-01-19T12:34:56.789",
    "startWeight": 70.0
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

      bodyGoalRepository = BodyGoalRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await bodyGoalRepository.fetchBodyGoal();

      // Assert
      expect(response.weight, 70.0);
      expect(response.goalType, GoalTyle.maintain);
      expect(response.weightThreshold, 20.0);
      expect(response.startDate, DateTime.parse('2023-01-19T12:34:56.789'));
      expect(response.startWeight, 70.0);
    });

    test('fetchBodyGoal throws Exception when API call fails', () async {
      // Arrange
      final uri =
          Uri.https('api.fitbit.com', '/1/user/-/body/log/weight/goal.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      bodyGoalRepository = BodyGoalRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await bodyGoalRepository.fetchBodyGoal(),
        throwsException,
      );
    });
  });
}
