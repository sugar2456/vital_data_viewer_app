class ApiErrorResponse {
  final bool success;
  final List<ApiError> errors;

  ApiErrorResponse({
    required this.success,
    required this.errors,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      success: json['success'] ?? false,
      errors: (json['errors'] as List<dynamic>)
          .map((error) => ApiError.fromJson(error as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ApiError {
  final String errorType;
  final String message;

  ApiError({
    required this.errorType,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      errorType: json['errorType'] ?? '',
      message: json['message'] ?? '',
    );
  }
}