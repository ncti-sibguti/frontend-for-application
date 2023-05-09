import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ncti/schedule/models/student_schedule.dart';
import 'package:ncti/schedule/models/teacher_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

//192.168.1.122
const String SERVER = 'http://25.28.126.117:8080/api';

class LoginRepositories {
  Future<bool> login(TextEditingController usernameController,
      TextEditingController passwordController) async {
    final username = usernameController.text;
    final password = passwordController.text;

    final url = Uri.parse('$SERVER/auth/login');
    final response = await http.post(
      url,
      body: jsonEncode({"username": username, "password": password}),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    usernameController.clear();
    passwordController.clear();

    if (response.statusCode == 200) {
      final decodedToken = jsonDecode(response.body);

      String accessToken = decodedToken['accessToken'];
      String refreshToken = decodedToken['refreshToken'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);

      return true;
    } else {
      GetToken().removeToken();
      return false;
    }
  }
}

class AuthorizationRepositories {
  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      return true;
    } else {
      GetToken().removeToken();
      return false;
    }
  }
}

class GetToken {
  Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('refreshToken');
    prefs.remove('accessToken');
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken != null) return accessToken;
    } catch (e) {
      debugPrint('GetAccessToken${e.toString()}');

      rethrow;
    }
    return null;
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');
      if (refreshToken != null) return refreshToken;
    } catch (e) {
      debugPrint('GetRefreshToken${e.toString()}');
      rethrow;
    }
    return null;
  }
}

class UpdateToken {
  Future updateToken() async {
    String? refreshToken = await GetToken().getRefreshToken();
    String url = "$SERVER/auth/refresh";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $refreshToken'
    });
    if (response.statusCode == 200) {
      // debugPrint('response yes');

      final decodedToken = jsonDecode(response.body);

      String accessToken = decodedToken['accessToken'];
      String refreshToken = decodedToken['refreshToken'];

      final prefs = await SharedPreferences.getInstance();
      // debugPrint(accessToken);
      // debugPrint(refreshToken);

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
    } else {
      GetToken().removeToken();
    }
  }
}

class GetScheduleRepositories {
  Future getStudentShedule() async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/student/schedule";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      // debugPrint('Расписание получено');

      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = deserializeStudentLessons(responseBody);

      return jsonData;
    } else {
      throw Exception('Failed to load student schedule');
    }
  }

  Future getTeacherShedule() async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/teacher/schedule";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      // debugPrint('Расписание получено');

      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = deserializeTeacherLessons(responseBody);
      return jsonData;
    } else {
      throw Exception('Failed to teacher student schedule');
    }
  }
}

class GetUser {
  Future<String> getStudent() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/student/profile";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      // debugPrint('Student получено');

      final responseBody = utf8.decode(response.bodyBytes);

      return responseBody;
    } else {
      throw Exception('Failed to load student');
    }
  }

  Future<String> getTeacher() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/teacher/profile";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      // debugPrint('Teacher получено');
      final responseBody = utf8.decode(response.bodyBytes);

      // debugPrint(responseBody);

      return responseBody;
    } else {
      throw Exception('Failed to load teacher');
    }
  }
}
