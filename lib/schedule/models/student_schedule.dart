import 'dart:convert';

class Teacher {
  String firstname;
  String lastname;
  String surname;

  Teacher({
    required this.firstname,
    required this.lastname,
    required this.surname,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      firstname: json['firstname'],
      lastname: json['lastname'],
      surname: json['surname'],
    );
  }
}

class StudentLesson {
  String day;
  int numberPair;
  Teacher teacher;
  String subject;
  String classroom;

  StudentLesson({
    required this.day,
    required this.numberPair,
    required this.teacher,
    required this.subject,
    required this.classroom,
  });

  factory StudentLesson.fromJson(Map<String, dynamic> json) {
    return StudentLesson(
      day: json['day'],
      numberPair: json['numberPair'],
      teacher: Teacher.fromJson(json['teacher']),
      subject: json['subject'],
      classroom: json['classroom'],
    );
  }
}

Map<String, List<StudentLesson>> deserializeStudentLessons(String jsonString) {
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final Map<String, List<StudentLesson>> lessons = {};

  for (final key in jsonMap.keys) {
    final List<dynamic> lessonList = jsonMap[key];

    final List<StudentLesson> lessonsForDay = [];

    for (final lesson in lessonList) {
      lessonsForDay.add(StudentLesson.fromJson(lesson));
    }

    lessons[key] = lessonsForDay;
  }

  return lessons;
}
