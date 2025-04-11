import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_data_viewer_app/const/response_type.dart';
import 'package:vital_data_viewer_app/repositories/impls/device_repository_impl.dart';

void main() {
  group('DeviceRepositoryImpl', () {
    late MockClient mockClient;
    late DeviceRepositoryImpl deviceRepository;

    setUp(() {
      mockClient = MockClient(
        (request) async {
          // モックのレスポンスを設定
          return http.Response(
              '''
                {
                  "battery": "High",
                  "batteryLevel": 100,
                  "deviceVersion": "Charge 3",
                  "id": "12345",
                  "lastSyncTime": "2023-01-19T12:34:56.789",
                  "type": "TRACKER"
                }
              ''',
              200);
        },
      );
      deviceRepository = DeviceRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );
    });

    test('fetchDevice returns DeviceResponse when API call is successful', () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1/user/-/devices.json');
      const mockResponse = '''
        {
          "battery": "High",
          "batteryLevel": 100,
          "deviceVersion": "Charge 3",
          "id": "12345",
          "lastSyncTime": "2023-01-19T12:34:56.789",
          "type": "TRACKER"
        }
      ''';

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response(mockResponse, 200);
        }
        return http.Response('Not Found', 404);
      });

      deviceRepository = DeviceRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act
      final response = await deviceRepository.fetchDevice();

      // Assert
      expect(response.battery, DeviceBattery.high);
      expect(response.batteryLevel, 100);
      expect(response.deviceVersion, 'Charge 3');
      expect(response.id, '12345');
      expect(response.lastSyncTime.toIso8601String(),
          '2023-01-19T12:34:56.789');
      expect(response.type, DeviceType.tracker);
    });

    test('fetchDevice throws Exception when API call fails', () async {
      // Arrange
      final uri = Uri.https('api.fitbit.com', '/1/user/-/devices.json');

      // モックの設定
      mockClient = MockClient((request) async {
        if (request.url == uri) {
          return http.Response('Unauthorized', 401);
        }
        return http.Response('Not Found', 404);
      });

      deviceRepository = DeviceRepositoryImpl(
        headers: {'Authorization': 'Bearer mock_token'},
        client: mockClient,
      );

      // Act & Assert
      expect(
        () async => await deviceRepository.fetchDevice(),
        throwsException,
      );
    });
  });
}