import 'package:flutter/material.dart';

import '../models/teacher_schedule.dart';

class TeacherLessonWidget extends StatelessWidget {
  final TeacherLesson lesson;

  const TeacherLessonWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    {
      return Card(
        color: Theme.of(context).cardColor,
        child: Row(
          children: [
            SizedBox(
              // padding: EdgeInsets.all(10),
              width: 40,
              child: Center(
                child: Text(
                  lesson.numberPair.toString(),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      lesson.subject,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  subtitle: Text(
                    'Группы ${lesson.groups} \nКабинет ${lesson.classroom}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}