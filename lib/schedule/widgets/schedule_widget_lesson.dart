import 'package:flutter/material.dart';
import 'package:ncti/schedule/models/day_model.dart';

class LessonWidget extends StatelessWidget {
  final Lesson lesson;

  LessonWidget({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Container(
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
              padding: EdgeInsets.only(left: 10),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    lesson.subject,
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
