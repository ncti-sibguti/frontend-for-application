import 'dart:convert';

class StudentLesson {
  String day;
  int numberPair;
  String subject;
  List<Teacher> teachers;
  String classroom;

  StudentLesson(
      {required this.day,
      required this.numberPair,
      required this.subject,
      required this.teachers,
      required this.classroom});

  factory StudentLesson.fromJson(Map<String, dynamic> json) {
    var teacherList = json['teachers'] as List;
    List<Teacher> teachers =
        teacherList.map((teacher) => Teacher.fromJson(teacher)).toList();

    // var classroomList = json['classroom'] as List;
    // List<Classroom> classrooms = classroomList
    //     .map((classroom) => Classroom.fromJson(classroom))
    //     .toList();

    return StudentLesson(
      day: json['day'],
      numberPair: json['numberPair'],
      subject: json['subject'],
      teachers: teachers,
      classroom: json['classroom'],
    );
  }
}

class Classroom {
  String name;

  Classroom({required this.name});
  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      name: json['name'],
    );
  }
}

class Teacher {
  String firstname;
  String lastname;
  String surname;

  Teacher(
      {required this.firstname, required this.lastname, required this.surname});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      firstname: json['firstname'],
      lastname: json['lastname'],
      surname: json['surname'],
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
