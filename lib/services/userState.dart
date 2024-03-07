// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String? _userId;
  String? _userRole;

  String? get userId => _userId;
  String? get userRole => _userRole;

  void login(String userId, String userRole) {
    _userId = userId;
    _userRole = userRole;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _userRole = null;
    notifyListeners();
  }
}
