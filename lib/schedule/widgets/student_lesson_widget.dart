import 'package:flutter/material.dart';

import '../models/student_schedule.dart';

class StudentLessonWidget extends StatelessWidget {
  final StudentLesson lesson;

  const StudentLessonWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
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
                    lesson.subject.name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                subtitle: Text(
                  '${lesson.teacher.lastname} ${lesson.teacher.firstname} ${lesson.teacher.surname}\nКабинет ${lesson.classroom}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
