import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/repositories/impls/calories_repository_impl.dart';

void main() {
  group('CaloriesRepositoryImpl', () {
    late MockClient mockClient;
    late CaloriesRepositoryImpl caloriesRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          return http.Response('Not Found', 404);
        },
      );
      caloriesRepository = CaloriesRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchCalories returns CaloriesResponse when API call is successful', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/calories/date/$date/1d/$detailLevel.json',
      );
      const mockResponse = '''
      {
        "activities-calories": [
          {
            "dateTime": "2023-01-19",
            "value": "3385"
          }
        ],
        "activities-calories-intraday": {
          "dataset": [
            { "time": "00:00:00", "value": 1.08618 },
            { "time": "00:01:00", "value": 1.194798 }
          ],
          "datasetInterval": 1,
          "datasetType": "minute"
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

      caloriesRepository = CaloriesRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await caloriesRepository.fetchCalories(date, detailLevel);

      // Assert
      expect(response.activitiesCalories[0].value, 3385.0);
      expect(response.activitiesCaloriesIntraday.dataset.length, 2);
      // 少数第2位で四捨五入している
      expect(response.activitiesCaloriesIntraday.dataset[0].value, 1.1);
    });

    test('fetchCalories throws Exception when API call fails', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/calories/date/$date/1d/$detailLevel.json',
      );

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      caloriesRepository = CaloriesRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await caloriesRepository.fetchCalories(date, detailLevel),
        throwsException,
      );
    });
  });
}