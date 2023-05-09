import 'package:flutter/material.dart';
import 'package:ncti/schedule/widgets/teacher_lesson_widget.dart';

import '../models/teacher_schedule.dart';

class TeacherDayWidget extends StatefulWidget {
  const TeacherDayWidget({super.key, required this.dataJson});

  // final TeacherLesson lesson;
  final dynamic dataJson;

  @override
  State<TeacherDayWidget> createState() => _TeacherDayWidgetState();
}

class _TeacherDayWidgetState extends State<TeacherDayWidget> {
  static List<String> daysOfWeek = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"];
  static List<String> lessonsOfWeek = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота"
  ];

  String selectedDay = lessonsOfWeek[0];

  List<TeacherLesson> getLessonsForDay(String day) {
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
          itemCount: lessonsOfWeek.length,
          itemBuilder: (context, int index) {
            return TextButton(
              onPressed: () => onDaySelected(lessonsOfWeek[index]),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) {
                  return selectedDay == lessonsOfWeek[index]
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary;
                }),
                foregroundColor: MaterialStateColor.resolveWith((states) {
                  return selectedDay == lessonsOfWeek[index]
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary;
                }),
              ),
              child: Text(daysOfWeek[index]),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TeacherLesson> lessons = getLessonsForDay(selectedDay);

    if (lessons.isNotEmpty) {
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
                    return TeacherLessonWidget(lesson: lessons[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
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
            Card(
                child: ListTile(
              title: Text('Пары отсутствуют',
                  style: Theme.of(context).textTheme.labelLarge),
            )),
          ],
        ),
      ));
    }
  }
}
