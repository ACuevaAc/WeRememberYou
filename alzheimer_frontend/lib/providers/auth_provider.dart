
import 'package:alzheimer_frontend/models/user_model.dart';
import 'package:alzheimer_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading=false;

  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser=> _currentUser;

  final AuthService _authService= AuthService();

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
      final user=await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirmation,
        phone: phone,
      );

      _isLoading=false;

      if(user!=null) {
        _currentUser=user;
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
}