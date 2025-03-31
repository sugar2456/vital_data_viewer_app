
class ExternalServiceException implements Exception{
  final String systemMessage;
  final String? userMessage;
  final int? statusCode;

  ExternalServiceException(this.systemMessage, this.userMessage, this.statusCode);

  @override
  String toString() {
    return 'ExternalServiceException: $systemMessage / $userMessage / Status Code: $statusCode';
  }
}