
import 'package:flutter/material.dart';
import 'package:ncti/schedule/models/day_model.dart';

class LessonWidget extends StatelessWidget {
  final Lesson lesson;

  LessonWidget({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(lesson.subject.name),
        subtitle: Text(
            '${lesson.teacher.lastname} ${lesson.teacher.firstname} ${lesson.teacher.surname}, Кабинет ${lesson.classroom}, #${lesson.numberPair}'),
      ),
    );
  }
}
