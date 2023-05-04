import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ncti/schedule/models/day_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/router.dart';

const String SERVER = 'http://25.28.126.117:8080/api';

class LoginRepositories {
  Future<bool> login(TextEditingController _usernameController,
      TextEditingController _passwordController) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // debugPrint('login $username');
    // debugPrint('pas $password');

    final url = Uri.parse('$SERVER/auth/login');
    final response = await http.post(
      url,
      body: jsonEncode({"username": username, "password": password}),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _usernameController.clear();
    _passwordController.clear();

    //response.statusCode == 200
    if (response.statusCode == 200) {
      // debugPrint('response yes');

      final decodedToken = jsonDecode(response.body);

      String accessToken = decodedToken['accessToken'];
      String refreshToken = decodedToken['refreshToken'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);

      // String? getAccessToken = prefs.getString('accessToken');
      // String? getRefreshToken = prefs.getString('refreshToken');

      // debugPrint('access $getAccessToken');
      // debugPrint('refresh $getRefreshToken');
      return true;
      // возвращает true || false
    } else {
      debugPrint('response no');
      return false;
    }
  }
}

// access eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiLQktC40YLQsNC70LjQudCQ0L3QtNGA0LXQtdCy0LjRhyIsInJvbGUiOlt7ImF1dGhvcml0eSI6IlJPTEVfU1RVREVOVCJ9XSwidXNlcl9pZCI6OSwiaXNzIjoibmN0aS1iYWNrZW5kIiwiZXhwIjoxNjgzMTMxNDM5LCJpYXQiOjE2ODI1MjY2Mzl9.5JRwZOk4XXe1JJTbXrHEvh-FuLZrHiEaExdD4YRpZPu2SmxUEodq9AzcI1Y2z44FBjv0EYKK-XB152Bko-SbXA
// // refresh eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiLQktC40YLQsNC70LjQudCQ0L3QtNGA0LXQtdCy0LjRhyIsImlzcyI6Im5jdGktYmFja2VuZCIsImV4cCI6MTY4MzczNjIzOSwiaWF0IjoxNjgyNTI2NjM5fQ.HDjCn0Z3r8MaV3bAYQbgubfjamDr9aSno0v_v8Hk1jLLiCqEGjswREaBkbe1ixvmIOdS4AXhMaP3KI9g7PMUJw
class AuthorizationRepositories {
  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    debugPrint('isLogin get access $refreshToken');

    if (refreshToken != null) {
      return true;
    } else {
      return false;
    }
  }
}

class GetToken {
  Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('refreshToken');
    prefs.remove('accessToken');

    debugPrint(prefs.getString('accessToken'));
    debugPrint(prefs.getString('refreshToken'));
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken != null) return accessToken;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');
      if (refreshToken != null) return refreshToken;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
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
      debugPrint('response yes');

      final decodedToken = jsonDecode(response.body);

      String accessToken = decodedToken['accessToken'];
      String refreshToken = decodedToken['refreshToken'];

      final prefs = await SharedPreferences.getInstance();
      // debugPrint(accessToken);
      // debugPrint(refreshToken);

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
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
      debugPrint('Расписание получено');

      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = deserializeLessons(responseBody);
      debugPrint(jsonData.toString());

      return jsonData;
    } else
      throw Exception('Failed to load student schedule');
  }

  Future getTeacherShedule() async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/teacher/schedule";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      debugPrint('Расписание получено');

      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = deserializeLessons(responseBody);

      return jsonData;
    } else
      throw Exception('Failed to load student schedule');
  }
}

class GetUser {
  Future getUser() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/api/";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      debugPrint('User получено');

      final responseBody = utf8.decode(response.bodyBytes);

      return responseBody;
    } else
      throw Exception('Failed to load user');
  }
}
