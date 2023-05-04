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

class Subject {
  String name;

  Subject({
    required this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
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

class Lesson {
  String day;
  int numberPair;
  Teacher teacher;
  Subject subject;
  String classroom;

  Lesson({
    required this.day,
    required this.numberPair,
    required this.teacher,
    required this.subject,
    required this.classroom,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      day: json['day'],
      numberPair: json['numberPair'],
      teacher: Teacher.fromJson(json['teacher']),
      subject: Subject.fromJson(json['subject']),
      classroom: json['classroom'],
    );
  }
}

Map<String, List<Lesson>> deserializeLessons(String jsonString) {
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final Map<String, List<Lesson>> lessons = {};

  for (final key in jsonMap.keys) {
    final List<dynamic> lessonList = jsonMap[key];

    final List<Lesson> lessonsForDay = [];

    for (final lesson in lessonList) {
      lessonsForDay.add(Lesson.fromJson(lesson));
    }

    lessons[key] = lessonsForDay;
  }

  return lessons;
}
