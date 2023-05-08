import 'dart:convert';

class Schedule {
  final Map<String, List<TeacherLesson>> data;

  Schedule({required this.data});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final Map<String, List<TeacherLesson>> data = {};

    json.forEach((key, value) {
      final List<TeacherLesson> lessons = [];

      for (final lessonJson in value) {
        final TeacherLesson lesson = TeacherLesson.fromJson(lessonJson);
        lessons.add(lesson);
      }

      data[key] = lessons;
    });

    return Schedule(data: data);
  }
}

class TeacherLesson {
  final int numberPair;
  final String subject;
  final String classroom;
  final List<String> groups;

  TeacherLesson(
      {required this.numberPair,
      required this.subject,
      required this.classroom,
      required this.groups});

  factory TeacherLesson.fromJson(Map<String, dynamic> json) {
    final List<String> groups = [];

    for (final group in json['groups']) {
      groups.add(group);
    }

    return TeacherLesson(
      numberPair: json['numberPair'],
      subject: json['subject'],
      classroom: json['classroom'],
      groups: groups,
    );
  }
}

Map<String, List<TeacherLesson>> deserializeTeacherLessons(String jsonString) {
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final Map<String, List<TeacherLesson>> lessons = {};

  for (final key in jsonMap.keys) {
    final List<dynamic> lessonList = jsonMap[key];

    final List<TeacherLesson> lessonsForDay = [];

    for (final lesson in lessonList) {
      lessonsForDay.add(TeacherLesson.fromJson(lesson));
    }

    lessons[key] = lessonsForDay;
  }

  return lessons;
}
