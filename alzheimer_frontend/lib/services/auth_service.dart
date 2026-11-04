import 'package:alzheimer_frontend/config/api_config.dart';
import 'package:alzheimer_frontend/models/user_model.dart';
import 'package:dio/dio.dart';

class AuthService {

  final Dio _dio=Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

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