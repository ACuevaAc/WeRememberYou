import 'package:wry_frontend/config/api_config.dart';
import 'package:wry_frontend/models/user_model.dart';
import 'package:wry_frontend/services/auth_service.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  Options _authOptions(String token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  Future<List<UserModel>> fetchUsers(String token) async {
    try {
      final response = await _dio.get(
        '/admin/users',
        options: _authOptions(token),
      );

      final List<dynamic> dataList = response.data;
      final List<UserModel> users = [];

      for (var item in dataList) {
        final userMap = Map<String, dynamic>.from(item);
        users.add(UserModel.fromJson(userMap));
      }

      return users;
    } on DioException catch (e) {
      String errorMessage = 'Error al obtener usuarios';

      final responseData = e.response?.data;

      if (responseData is Map && responseData['message'] != null) {
        errorMessage = responseData['message'].toString();
      }

      throw ApiException(
        errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }
  Future<void> toggleActive(int id, String token) async {
  await _dio.patch(
    '/admin/users/$id/toggle-active',
    options: _authOptions(token),
  );
}
  Future<void> deleteUser(int id,String token) async {
    await _dio.delete(
      '/admin/users/$id',
      options: _authOptions(token)
    );
  }
  Future<UserModel> updateUser({
    required int id,
    required String token,
    required String name,
    required String email,
    required String role,
    String? phone,
  }) async {
    final response=  await _dio.put('/admin/users/$id',
    options: _authOptions(token),
    data: {
      'name':name,
      'email':email,
      'phone':phone,
      'role':role
    },
    );

    return UserModel.fromJson(
      Map<String,dynamic>.from(response.data['user'])
    );
  }
    
}
