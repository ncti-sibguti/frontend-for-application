import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/models/student_schedule.dart';
import 'package:ncti/schedule/models/teacher_schedule.dart';

import 'package:http/http.dart' as http;

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

  Future getScheduleGroup(String groupId) async {
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/user/groups/$groupId";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);

      final jsonData = deserializeStudentLessons(responseBody);
      debugPrint(jsonData.toString());
      return jsonData;
    } else {
      throw Exception('Failed to  student schedule');
    }
  }

  Future editClassroom(DateTime day, List<String> group, String subject,
      int numberPair, TextEditingController controller) async {
    String classroom = controller.text;
    String? accessToken = await GetToken().getAccessToken();

    String url = "$SERVER/teacher/change-schedule";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        "date": day.toString(),
        "group": group,
        "subject": subject,
        "numberPair": numberPair,
        "classroom": 'Кабинет $classroom'
      }),
    );
    debugPrint(response.body);
    return response;
  }
}
