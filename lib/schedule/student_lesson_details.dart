import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';

import 'models/student_schedule.dart';

@RoutePage()
class StudentLessonDetailsPage extends StatelessWidget {
  final StudentLesson lesson;

  StudentLessonDetailsPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'тук',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
