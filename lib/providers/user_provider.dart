import 'dart:convert';
import 'dart:io';

import 'package:flash_retail/models/user_model.dart';
import 'package:flash_retail/services/userService.dart';
import 'package:flash_retail/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;

  User? get user => _user;
  final GetStorage box = GetStorage();

  Future<User?> createUser(User user, {File? image}) async {
    final newUser = await _userService.createUser(user, image: image);
    if (newUser != null) {
      _user = newUser;
      notifyListeners();
    }
    return newUser;
  }

  Future<bool> login(String email, String password) async {
    try {
      User? user = await _userService.login(email, password);
      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error logging in: $e');
    }
    return false;
  }

  Future<bool> loadUserFromStorage() async {
    if (box.hasData(kUserInfo)) {
      try {
        var userDataString =
            box.read<String>(kUserInfo); // Retrieve the JSON string
        var userData = json.decode(userDataString!); // Decode it into a Map
        _user = User.fromJson(userData as Map<String, dynamic>);
        notifyListeners();
        return true;
      } catch (e) {
        print("Failed to load user: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> updateUser(User updatedUser, {File? image}) async {
    try {
      final updatedUserFromService =
          await _userService.updateUser(updatedUser, image: image);
      if (updatedUserFromService != null) {
        _user = updatedUserFromService;
        // Save updated user to local storage
        await box.write(kUserInfo, json.encode(_user!.toJson()));
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error updating user: $e');
    }
    return false;
  }

  Future<bool> deleteUser() async {
    try {
      final success = await _userService.deleteUser(_user!.id!);
      if (success) {
        _userService.clearUser(); // Clear user data from local storage

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
    return false;
  }

  //change use password
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    // if (_user == null) return false;

    try {
      bool success = await _userService.changePassword(
          _user!.id!, currentPassword, newPassword);
      if (success) {
        return true;
      }
    } catch (e) {
      print('Error changing password: $e');
    }
    return false;
  }

  Future<bool> updatePassword(String newPassword) async {
    // if (_user == null) return false;

    try {
      bool success = await _userService.updatePassword(_user!.id!, newPassword);
      if (success) {
        return true;
      }
    } catch (e) {
      print('Error changing password: $e');
    }
    return false;
  }

  void logout() {
    _userService.clearUser(); // Clear user data from local storage
    _user = null;
    notifyListeners();
  }
}
