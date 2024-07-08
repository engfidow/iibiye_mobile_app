import 'dart:convert';

import 'package:flash_retail/models/user_model.dart';
import 'package:flash_retail/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';

class UserService {
  final box = GetStorage();
  final String baseUrl = kEndpoint;

  Future<User?> createUser(User user, {File? image}) async {
    var uri = Uri.parse('$baseUrl/customers/signup');
    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = user.name!
      ..fields['email'] = user.email!
      ..fields['password'] = user.password!
      ..fields['gender'] = user.gender!;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      var userData = json.decode(response.body);
      saveUser(User.fromJson(userData)); // Save the user
      return User.fromJson(userData);
    } else {
      print('Failed to create user: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<User?> login(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/customers/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var userData = json.decode(response.body);
      saveUser(User.fromJson(userData)); // Save the user
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Retrieve user from local storage
  User? getUser() {
    var userData = box.read(kUserInfo);

    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }

  Future<User?> updateUser(User user, {File? image}) async {
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/customers/${user.id}'));

      if (image != null) {
        final mimeTypeData = lookupMimeType(image.path)!.split('/');
        request.files.add(
          http.MultipartFile(
            'image',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.path.split('/').last,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      request.fields['name'] = user.name!;
      request.fields['email'] = user.email!;
      request.fields['gender'] = user.gender!;
      // Password should not be sent if not changing, handle that logic here if necessary

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        return User.fromJson(jsonDecode(responseBody.body));
      }
    } catch (e) {
      print('Error updating user: $e');
    }
    return null;
  }

  //delete user by id
  Future<bool> deleteUser(String userId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/customers/$userId'));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
    return false;
  }

  //change user password
  Future<bool> changePassword(
      String userId, String currentPassword, String newPassword) async {
    var response = await http.post(
      Uri.parse('$baseUrl/customers/change-password'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to change password: ${response.body}');
      return false;
    }
  }

  Future<bool> updatePassword(String userId, String newPassword) async {
    var response = await http.post(
      Uri.parse('$baseUrl/customers/update'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'userId': userId,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // User.fromJson(jsonDecode(response.body));
      return true;
    } else {
      print('Failed to change password: ${response.body}');
      return false;
    }
  }

  void saveUser(User user) {
    box.write(kUserInfo, json.encode(user.toJson()));
  }

  void clearUser() {
    box.remove(kUserInfo);
  }
}
