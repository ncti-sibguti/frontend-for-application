import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/routes/router.dart';

import '../models/student_schedule.dart';

class StudentLessonWidget extends StatelessWidget {
  final StudentLesson lesson;
  final DateTime day;

  const StudentLessonWidget(
      {super.key, required this.lesson, required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            AutoRouter.of(context).push(StudentLessonDetailsRoute(
                lesson: lesson)); // Действие при нажатии на элемент расписания
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                        '${lesson.teachers.map((e) => '${e.lastname} ${e.firstname} ${e.surname}').join(', \n')} \n${lesson.classroom}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
