import 'dart:convert';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ncti/schedule/models/student_schedule.dart';
import 'package:ncti/schedule/models/teacher_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/io.dart';

//192.168.1.122
const String SERVER = 'http://25.28.126.117:8080/api';
const String WEBSERVER = 'ws://25.28.126.117:8080/api';

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
      debugPrint('изменился');
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

class GetScheduleRepositories {
  Future getStudentSchedule() async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/student/schedule";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = deserializeStudentLessons(responseBody);
      return jsonData;
    } else {
      throw Exception('Failed to load student schedule');
    }
  }

  Future getTeacherSchedule() async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/teacher/schedule";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
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
}

class GetChat {
  Future getChats() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/chats";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final res = parseGroups(responseBody);
      return res;
    } else {
      throw Exception('failed to load chat');
    }
  }

  Future getMessages(String chatId) async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/chats/$chatId";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final messages = (jsonDecode(responseBody) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();
      return messages;
    } else {
      throw Exception('failed to load chat');
    }
  }

  Future postMessage(String text, String chatId) async {
    String? accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$SERVER/chats/$chatId');
    final response = await http.post(
      url,
      body: jsonEncode({"text": text}),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
  }

  Future createChat(String name, List<int> selectedUser) async {
    String? accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$SERVER/chats/create/');
    final response = await http.post(
      url,
      body: jsonEncode({"name": name, "ids": selectedUser}),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    debugPrint(response.body);
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
