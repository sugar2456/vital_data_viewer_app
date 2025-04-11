import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/repositories/impls/swimming_repository_impl.dart';

void main() {
  group('SwimmingRepositoryImpl', () {
    late MockClient mockClient;
    late SwimmingRepositoryImpl swimmingRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
              '{"activities-swimming-strokes": [], "activities-swimming-strokes-intraday": {"dataset": []}}',
              200);
        },
      );
      swimmingRepository = SwimmingRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchSwimming returns SwimmingResponse when API call is successful', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/swimming-strokes/date/$date/1d/$detailLevel.json',
      );
      const mockResponse = '''
      {
        "activities-swimming-strokes": [
          {
            "dateTime": "2023-01-19",
            "value": "100"
          }
        ],
        "activities-swimming-strokes-intraday": {
          "dataset": [
            { "time": "00:00:00", "value": 10 },
            { "time": "00:01:00", "value": 15 }
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

      swimmingRepository = SwimmingRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await swimmingRepository.fetchSwimming(date, detailLevel);

      // Assert
      expect(response.activitiesSwimmingStroke[0].value, 100);
      expect(response.activitiesSwimmingStrokeIntraday.dataset.length, 2);
      expect(response.activitiesSwimmingStrokeIntraday.dataset[0].value, 10);
    });

    test('fetchSwimming throws Exception when API call fails', () async {
      // Arrange
      const date = '2023-01-19';
      const detailLevel = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/swimming-strokes/date/$date/1d/$detailLevel.json',
      );

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      swimmingRepository = SwimmingRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await swimmingRepository.fetchSwimming(date, detailLevel),
        throwsException,
      );
    });
  });
}