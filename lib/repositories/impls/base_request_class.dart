import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/const/http_status_code.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import 'package:vital_data_viewer_app/models/response/error/api_error_response.dart';

abstract class BaseRequestClass {
  final http.Client client;

  BaseRequestClass({required this.client});

  /// GETリクエストを送信するメソッド<br>
  /// [uri] リクエスト先のURI<br>
  /// [headers] リクエストヘッダー<br>
  /// [return] レスポンスのボディをMap<String, dynamic>として返す<br>
  /// [throws] ExternalServiceException<br>
  /// [throws] Exception<br>
  Future<Map<String, dynamic>> get(
      Uri uri, Map<String, String> headers) async {
    try {
      final response = await client.get(uri, headers: headers);

      switch (response.statusCode) {
        case HttpStatusCode.ok:
          return json.decode(response.body) as Map<String, dynamic>;
          
        case HttpStatusCode.badRequest:
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = '不正なリクエストです。';
          final systemMessage = errorResponse.errors[0].message;
          log('HTTPエラー: ${response.statusCode}');
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.unauthorized:
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = '認証エラーが発生しました。再度ログインを行ってください。';
          final systemMessage = errorResponse.errors[0].message;
          log('HTTPエラー: ${response.statusCode}');
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.forbidden:
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = 'このユーザではこのリソースにアクセスできません';
          final systemMessage = errorResponse.errors[0].message;
          log('HTTPエラー: ${response.statusCode}');
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.notFound:
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = 'リソースが見つかりません';
          final systemMessage = errorResponse.errors[0].message;
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.methodNotAllowed:
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = 'HTTPメソッドが許可されていません';
          final systemMessage = errorResponse.errors[0].message;
          log('HTTPエラー: ${response.statusCode}');
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.tooManyRequests:
          log('HTTPエラー: ${response.statusCode}');
          final errorResponseJson = json.decode(response.body);
          const userMessage = 'リクエストが多すぎます。しばらく待ってから再試行してください。';
          final systemMessage = errorResponseJson['error']['message'];
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);

        case HttpStatusCode.internalServerError:
          log('HTTPエラー: ${response.statusCode}');
          final errorResponseJson = json.decode(response.body);
          final errorResponse = ApiErrorResponse.fromJson(errorResponseJson);
          const userMessage = 'サーバーエラーが発生しました。';
          final systemMessage = errorResponse.errors[0].message;
          throw ExternalServiceException(
              systemMessage, userMessage, response.statusCode);
        default:
          log('HTTPエラー: ${response.statusCode}');
          throw Exception('HTTPリクエストに失敗しました');
      }
    } catch (e, stackTrace) {
      log('HTTPリクエストエラー: $e');
      log(stackTrace.toString());

      if (e is ExternalServiceException) {
        rethrow;
      }

      // その他の例外を再スロー
      throw Exception('HTTPリクエストに失敗しました: $e');
    }
  }
}
