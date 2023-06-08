import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/routes/router.dart';

// import '../models/student_schedule.dart';

class LessonWidget extends StatelessWidget {
  final dynamic lesson;
  final DateTime day;
  final bool isTeacher;

  const LessonWidget(
      {super.key,
      required this.lesson,
      required this.day,
      required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            AutoRouter.of(context).push(LessonDetailsRoute(
                lesson: lesson,
                day: day,
                isTeacher:
                    isTeacher)); // Действие при нажатии на элемент расписания
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  // padding: EdgeInsets.all(10),

                  child: Center(
                    child: Text(
                      lesson.numberPair.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.subject,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          isTeacher
                              ? 'Группы ${lesson.groups.join(', \n')}'
                              : '${lesson.teachers.map((e) => '${e.lastname} ${e.firstname} ${e.surname}').join(', \n')}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          lesson.classroom,
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
