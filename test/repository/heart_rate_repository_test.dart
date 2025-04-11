import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/repositories/impls/heart_rate_repository_impl.dart';

void main() {
  group('HeartRateRepositoryImpl', () {
    late MockClient mockClient;
    late HeartRateRepositoryImpl heartRateRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
              '{"activities-heart": [], "activities-heart-intraday": {"dataset": []}}',
              200);
        },
      );
      heartRateRepository = HeartRateRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchHeartRate returns HeartRateResponse when API call is successful', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/heart/date/$date/1d/$detailLevel.json',
      );
      const mockResponse = '''
      {
        "activities-heart": [
          {
            "dateTime": "2023-01-19",
            "value": {
              "customHeartRateZones": [],
              "heartRateZones": [],
              "restingHeartRate": 60
            }
          }
        ],
        "activities-heart-intraday": {
          "dataset": [
            { "time": "00:00:00", "value": 70 },
            { "time": "00:01:00", "value": 72 }
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

      heartRateRepository = HeartRateRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await heartRateRepository.fetchHeartRate(date, detailLevel);

      // Assert
      expect(response.activitiesHeartRate[0].value.restingHeartRate, 60);
      expect(response.activitiesHeartRateIntraday.dataset.length, 2);
      expect(response.activitiesHeartRateIntraday.dataset[0].value, 70);
    });

    test('fetchHeartRate throws Exception when API call fails', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/heart/date/$date/1d/$detailLevel.json',
      );

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      heartRateRepository = HeartRateRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await heartRateRepository.fetchHeartRate(date, detailLevel),
        throwsException,
      );
    });
  });
}