import 'package:contacts_flutter/utils/api_error_response.dart';
import 'package:dio/dio.dart';

ApiErrorResponse getErrorResponse(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'connection timeout',
      );
    case DioExceptionType.sendTimeout:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'send timeout',
      );
    case DioExceptionType.receiveTimeout:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'receive timeout',
      );
    case DioExceptionType.badCertificate:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'bad certificate',
      );
    case DioExceptionType.badResponse:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: e.response?.data['message'] ?? 'bad response',
      );
    case DioExceptionType.cancel:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'request cancelled',
      );
    case DioExceptionType.connectionError:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'connection error',
      );
    case DioExceptionType.unknown:
      return ApiErrorResponse(
        status: e.response?.statusCode.toString() ?? '404',
        message: 'unexpected error',
      );
  }
}
