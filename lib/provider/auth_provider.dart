import 'package:flutter/material.dart';
import 'package:navigator/db/AuthRepository.dart';
import 'package:navigator/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);
  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();
    final userState = await authRepository.getUser();
    if (user == userState) {
      await authRepository.login();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.saveUser(user);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}
