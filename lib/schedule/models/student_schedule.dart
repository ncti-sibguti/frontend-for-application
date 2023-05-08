import 'dart:convert';

class Teacher {
  String firstname;
  String lastname;
  String surname;
  String email;
  List<Role> roles;

  Teacher({
    required this.firstname,
    required this.lastname,
    required this.surname,
    required this.email,
    required this.roles,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      firstname: json['firstname'],
      lastname: json['lastname'],
      surname: json['surname'],
      email: json['email'],
      roles: (json['roles'] != null)
          ? List<Role>.from(
              json['roles'].map((role) => Role.fromJson(role)),
            )
          : [],
    );
  }
}

class Role {
  String name;

  Role({
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
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
