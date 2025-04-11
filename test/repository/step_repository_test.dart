import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/repositories/impls/step_repository_impl.dart';

void main() {
  group('StepResponseImpl', () {
    late MockClient mockClient;
    late StepResponseImpl stepResponseImpl;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response('{"activities-steps": []}', 200);
        },
      );
      stepResponseImpl = StepResponseImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchStep returns StepResponse when API call is successful', () async {
      // Arrange
      const date = '2023-01-19';
      const min = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/steps/date/$date/1d/$min.json',
      );
      const mockResponse = '''
      {
        "activities-steps": [
          {
            "dateTime": "2023-01-19",
            "value": "10000"
          }
        ],
        "activities-steps-intraday": {
          "dataset": [
            { "time": "00:00:00", "value": 50 },
            { "time": "00:01:00", "value": 60 }
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

      stepResponseImpl = StepResponseImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await stepResponseImpl.fetchStep(date, min);

      // Assert
      expect(response.activitiesSteps[0].value, 10000);
      expect(response.activitiesStepsIntraday.dataset.length, 2);
    });

    test('fetchStepPeriod returns StepResponse when API call is successful',
        () async {
      // Arrange
      const startDate = '2023-01-19';
      const endDate = '2023-01-19';
      const min = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/steps/date/$startDate/$endDate/$min.json',
      );
      const mockResponse = '''
      {
        "activities-steps": [
          {
            "dateTime": "2023-01-19",
            "value": "10000"
          }
        ],
        "activities-steps-intraday": {
          "dataset": [
            { "time": "00:00:00", "value": 50 },
            { "time": "00:01:00", "value": 60 }
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

      stepResponseImpl = StepResponseImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response =
          await stepResponseImpl.fetchStepPeriod(startDate, endDate, min);

      // Assert
      expect(response.activitiesSteps[0].value, 10000);
      expect(response.activitiesStepsIntraday.dataset.length, 2);
    });

    test('fetchStep throws Exception when API call fails', () async {
      // Arrange
      const date = '2023-01-19';
      const min = '1min';
      final uri = Uri.https(
        'api.fitbit.com',
        '/1/user/-/activities/steps/date/$date/1d/$min.json',
      );

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      stepResponseImpl = StepResponseImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await stepResponseImpl.fetchStep(date, min),
        throwsException,
      );
    });
  });
}