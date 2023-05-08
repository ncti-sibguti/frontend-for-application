import 'package:flutter/material.dart';
import 'package:ncti/schedule/widgets/student_lesson_widget.dart';

import '../models/student_schedule.dart';
import '../models/teacher_schedule.dart';

class StudentDayWidget extends StatefulWidget {
  const StudentDayWidget({super.key, required this.dataJson});

  static List<String> daysOfWeek = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"];
  static List<String> lessonsOfWeek = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота"
  ];

  // final TeacherLesson lesson;
  final dynamic dataJson;

  @override
  State<StudentDayWidget> createState() => _StudentDayWidgetState();
}

class _StudentDayWidgetState extends State<StudentDayWidget> {
  String selectedDay = StudentDayWidget.lessonsOfWeek[0];

  List<StudentLesson> _getLessonsForDay(String day) {
    switch (day) {
      case 'Понедельник':
        if (widget.dataJson.containsKey('Понедельник')) {
          return widget.dataJson['Понедельник']!;
        } else {
          return [];
        }
      case 'Вторник':
        if (widget.dataJson.containsKey('Вторник')) {
          return widget.dataJson['Вторник']!;
        } else {
          return [];
        }
      case 'Среда':
        if (widget.dataJson.containsKey('Среда')) {
          return widget.dataJson['Среда']!;
        } else {
          return [];
        }
      case 'Четверг':
        if (widget.dataJson.containsKey('Четверг')) {
          return widget.dataJson['Четверг']!;
        } else {
          return [];
        }
      case 'Пятница':
        if (widget.dataJson.containsKey('Пятница')) {
          return widget.dataJson['Пятница']!;
        } else {
          return [];
        }
      case 'Суббота':
        if (widget.dataJson.containsKey('Суббота')) {
          return widget.dataJson['Суббота']!;
        } else {
          return [];
        }
      default:
        return [];
    }
  }

  Widget _buildDaysButtons() {
    void onDaySelected(String day) {
      setState(() {
        selectedDay = day;
      });
    }

    return SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: StudentDayWidget.lessonsOfWeek.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              onPressed: () =>
                  onDaySelected(StudentDayWidget.lessonsOfWeek[index]),
              child: Text(StudentDayWidget.daysOfWeek[index]),
            );

            // return Row(
            //   children: daysOfWeek.map((day) {
            //     return
            //   }).toList(),
            // );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StudentLesson> lessons = _getLessonsForDay(selectedDay);

    if (lessons.isEmpty) {
      return Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            _buildDaysButtons(),
            const SizedBox(
              height: 15.0,
            ),
            Card(
                child: ListTile(
              title: Text('Пары отсутствуют',
                  style: Theme.of(context).textTheme.labelLarge),
            )),
          ],
        ),
      ));
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              _buildDaysButtons(),
              const SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StudentLessonWidget(lesson: lessons[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
