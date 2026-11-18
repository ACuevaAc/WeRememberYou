import 'package:alzheimer_frontend/models/user_model.dart';
import 'package:alzheimer_frontend/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  final UserService _userService= UserService();
  List<UserModel> _users=[];

  List<UserModel> get users => _users;

  bool _isLoading=false;
  bool get isLoading=> _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers(String token) async {
    _isLoading=true;
    _errorMessage= null;
    notifyListeners();

    try {
        _users= await  _userService.fetchUsers(token);
    } catch (e) {
      _errorMessage=e.toString();
    } finally {
      _isLoading=false;
      notifyListeners();
    }
  }
  Future<bool> togleActive(int id,String token)  async{
    _errorMessage = null;
    try {
      await _userService.toggleActive(id, token);
      await fetchUsers(token);
      return _errorMessage == null;
    } catch (e) {
      _errorMessage= e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> deleteUser(int id,String token) async {
    _errorMessage=null;
    try {
      await _userService.deleteUser(id, token);
      _users.removeWhere((user) => user.id==id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage=e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> updateUser({
    required int id,
    required String token,
    required String name,
    required String email,
    required String role,
    String? phone
  }) async {
    _errorMessage=null;
    try {
      await _userService.updateUser(id: id, token: token, name: name, email: email, role: role);
      await fetchUsers(token);
      return _errorMessage==null;
    } catch (e) {
      _errorMessage=e.toString();
      notifyListeners();
      return false;
    } 
  }
  Future<void> activateUser(int id) async {

  }
}