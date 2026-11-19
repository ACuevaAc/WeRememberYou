import 'package:wry_frontend/config/api_config.dart';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
  
}

class AuthService {
  
  ApiException _apiError(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;

  if (data is Map) {
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      return ApiException(
        first is List ? first.first.toString() : first.toString(),
        statusCode: status,
      );
    }

    final message = data['message'];
    if (message != null) {
      return ApiException(message.toString(), statusCode: status);
    }
  }

  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.connectionError) {
    return ApiException('No se pudo conectar con el servidor.');
  }

  return ApiException('Error de conexión (${status ?? 'sin respuesta'})');
}

  final Dio _dio=Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    return Map<String, dynamic>.from(response.data as Map);
  } on DioException catch (e) {
    throw _apiError(e);
  }
}

  Future<Map<String,dynamic>?> registerUser ({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    String? phone,
  }) async {
    try {
      final response= await _dio.post(
        '/register',
        data: {
          'name':name,
          'email':email,
          'password': password,
          'password_confirmation':passwordConfirm,
          'role': 'u',
          'phone':phone,
          'is_active': true,
        },
      );
      if(response.statusCode==201 || response.statusCode==200) {
        final responseData=response.data;
        return {
          'access_token':responseData['access_token'],
          'user': responseData['user']
        };
      }
      return null;
    } on DioException catch(e) {
      print("ERROR STATUS: ${e.response?.statusCode}");
      print("ERROR DATA: ${e.response?.data}");
      print("ERROR MENSAJE: ${e.message}");
      print("REQUEST DATA: ${e.requestOptions.data}");
      return null;
    } catch (e) {
      print("ERROR TEST NO ESPERADO: $e");
      return null;
    }
  }
}