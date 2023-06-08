import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

//94.154.11.150
//25.28.126.117

String SERVER = dotenv.get('SERVER');

class NotificationRep {
  Future<void> postToken() async {
    String? accessToken = await GetToken().getAccessToken();

    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('отправлено $token');

    final url = Uri.parse('$SERVER/user/fcm-token');
    final response = await http.post(
      url,
      body: jsonEncode({'token': token}),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    debugPrint(response.body);
  }
}

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

  Future changePassword(TextEditingController passwordController) async {
    String? accessToken = await GetToken().getAccessToken();

    final password = passwordController.text;
    final url = Uri.parse('$SERVER/user/change-password');
    final response = await http.patch(
      url,
      body: jsonEncode({"password": password}),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    passwordController.clear();

    if (response.statusCode == 200) {
      return true;
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

class GetUser {
  Future<String> getStudent() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/student/profile";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
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
      final responseBody = utf8.decode(response.bodyBytes);

      return responseBody;
    } else {
      throw Exception('Failed to load teacher');
    }
  }

  Future getAllUser() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/user/users";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final respon = parseUsers(responseBody);
      // debugPrint(respon.toString());
      return respon;
    } else {
      throw Exception('Failed to load all user');
    }
  }

  Future getAllGroup() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/user/groups";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);

      List<dynamic> jsonList = jsonDecode(responseBody);
      List<ScheduleGroup> scheduleGroup =
          jsonList.map((json) => ScheduleGroup.fromJson(json)).toList();

      return scheduleGroup;
    } else {
      throw Exception('Failed to load all group');
    }
  }
}

class ScheduleGroup {
  int id;
  String name;

  ScheduleGroup({required this.id, required this.name});

  factory ScheduleGroup.fromJson(Map<String, dynamic> json) {
    return ScheduleGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Group {
  String id;
  String name;
  int userCount;
  // String type;

  Group({
    required this.id,
    required this.name,
    required this.userCount,
    // required this.type
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      userCount: json['userCount'],
      // type: json['type'],
    );
  }
}

List<Group> parseGroups(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Group>((json) => Group.fromJson(json)).toList();
}

class User {
  int id;
  String firstName;
  String lastName;
  String surname;
  String email;
  String username;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.surname,
      required this.email,
      required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      surname: json['surname'],
      email: json['email'],
      username: json['username'],
    );
  }
}

List<User> parseUsers(String jsonString) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}
