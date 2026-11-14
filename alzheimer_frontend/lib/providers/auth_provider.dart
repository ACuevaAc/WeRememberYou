
import 'dart:convert';

import 'package:alzheimer_frontend/models/user_model.dart';
import 'package:alzheimer_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading=false;

  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser=> _currentUser;
  
  String? _token;
  String? get token => _token;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated =>  _token != null;
  String? get role => _currentUser?.role;

  final AuthService _authService= AuthService();
  final _storage = FlutterSecureStorage();

  AuthProvider() {
    _tryAutoLogin();
  }
  
   Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

   try {
      final data = await _authService.login(email: email, password: password);
     return await _saveSession(data);
    } on ApiException catch (e) {
     _errorMessage = e.message;
     return false;
    } catch (e) {
     debugPrint('Error inesperado en login: $e');
     _errorMessage = 'Ha ocurrido un error inesperado.';
     return false;
    } finally {
     _isLoading = false;
     notifyListeners();
    }
  }

  Future<void> logout() async {
  _token = null;
  _currentUser = null;
  _errorMessage = null;
  notifyListeners();

  await _storage.delete(key: 'token');
  await _storage.delete(key: 'user_data');
}

Future<bool> _saveSession(Map<String, dynamic> data) async {
  final token = data['access_token'];
  final userJson = data['user'];

  // Validar ANTES de guardar nada.
  if (token == null || userJson is! Map) {
    _errorMessage = 'Respuesta del servidor no válida.';
    return false;
  }

  _token = token.toString();
  _currentUser = UserModel.fromJson(Map<String, dynamic>.from(userJson));

  try {
    await _storage.write(key: 'token', value: _token);
    await _storage.write(
      key: 'user_data',
      value: jsonEncode(_currentUser!.toJson()),
    );
  } catch (e) {
    debugPrint('No se pudo guardar la sesión: $e');
  }

  return true;
}

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    }) async {
    _isLoading=true;
    notifyListeners();

    try {
      final responseData=await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirmation,
        phone: phone,
      );

      _isLoading=false;

      if (responseData!=null && responseData['access_token'] != null) {
        _token= responseData['access_token'];
        if(responseData['user']!=null) {
          _currentUser= UserModel.fromJson(responseData['user']);
        }

        await _storage.write(key: 'token',value: _token);
        await _storage.write(key: 'user_data',value: jsonEncode(_currentUser!.toJson()));

        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading=false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> _tryAutoLogin() async{
    final savedToken= await _storage.read(key: 'token');
    final savedUserData= await _storage.read(key: 'user_data');

    if(savedToken != null && savedUserData!= null) {
      _token= savedToken;
      _currentUser= UserModel.fromJson(jsonDecode(savedUserData));
      notifyListeners();
    }

  }
}