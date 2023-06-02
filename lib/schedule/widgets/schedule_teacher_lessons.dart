import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncti/schedule/models/teacher_schedule.dart';

import 'package:ncti/schedule/widgets/teacher_lesson_widget.dart';

class TeacherDayWidget extends StatefulWidget {
  const TeacherDayWidget({super.key, required this.dataJson});

  final dynamic dataJson;

  @override
  State<TeacherDayWidget> createState() => _TeacherDayWidgetState();
}

class _TeacherDayWidgetState extends State<TeacherDayWidget> {
  static List<String> daysOfWeek = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"];

  static int weekdayInt = (DateTime.now().weekday - 1);
  String? selectedDay;
  final PageController _pageController =
      PageController(initialPage: weekdayInt);
  int currentPageIndex = 0;
  DateTime day = DateTime.now();
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDay = daysOfWeek[weekdayInt];
    });
  }

  DateTime getDateTimeForDayOfWeek(int dayOfWeek) {
    // Получаем текущую дату
    DateTime currentDate = DateTime.now();

    // Вычисляем разницу между номером текущего дня недели и нужным нам днем недели
    int difference = dayOfWeek - currentDate.weekday;

    // Добавляем разницу к текущей дате, чтобы получить нужную дату дня недели
    DateTime desiredDate = currentDate.add(Duration(days: difference));

    return desiredDate;
  }

  List<TeacherLesson> getLessonsForDay(int day) {
    switch (day) {
      case 0:
        if (widget.dataJson.containsKey('Понедельник')) {
          return widget.dataJson['Понедельник'];
        } else {
          return [];
        }
      case 1:
        if (widget.dataJson.containsKey('Вторник')) {
          return widget.dataJson['Вторник'];
        } else {
          return [];
        }
      case 2:
        if (widget.dataJson.containsKey('Среда')) {
          return widget.dataJson['Среда'];
        } else {
          return [];
        }
      case 3:
        if (widget.dataJson.containsKey('Четверг')) {
          return widget.dataJson['Четверг'];
        } else {
          return [];
        }
      case 4:
        if (widget.dataJson.containsKey('Пятница')) {
          return widget.dataJson['Пятница'];
        } else {
          return [];
        }
      case 5:
        if (widget.dataJson.containsKey('Суббота')) {
          return widget.dataJson['Суббота'];
        } else {
          return [];
        }
      default:
        return [];
    }
  }

  Widget _buildDaysButtons() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: daysOfWeek.length,
          itemBuilder: (context, int pageIndex) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 1 / daysOfWeek.length,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) {
                    return selectedDay == daysOfWeek[pageIndex]
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary;
                  }),
                  foregroundColor: MaterialStateColor.resolveWith((states) {
                    return selectedDay == daysOfWeek[pageIndex]
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _pageController.jumpToPage(
                        pageIndex); // Обновляем индекс текущей страницы
                  });
                },
                child: Text(daysOfWeek[pageIndex]),
              ),
            );
          }),
    );
  }

  void onDaySelected(String day) {
    setState(() {
      selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.dataJson.toString());
    // if (lessons.isNotEmpty) {
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        SizedBox(height: 40, child: _buildDaysButtons()),
        const SizedBox(
          height: 16.0,
        ),
        Expanded(
          child: PageView.builder(
            onPageChanged: (int pageIndex) =>
                onDaySelected(daysOfWeek[pageIndex]),
            controller: _pageController,
            itemBuilder: (context, pageIndex) {
              DateTime day = getDateTimeForDayOfWeek(pageIndex + 1);
              List<TeacherLesson> lessons = getLessonsForDay(pageIndex);
              Intl.defaultLocale = 'ru_RU';
              String formatedDate = DateFormat.yMMMMEEEEd().format(day);

              if (lessons.isNotEmpty) {
                return Column(
                  children: [
                    Text(formatedDate),
                    Expanded(
                        child: ListView.builder(
                      itemCount: lessons.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TeacherLessonWidget(
                          lesson: lessons[index],
                          day: day,
                        );
                      },
                    ))
                  ],
                );
              } else {
                return Center(
                  child: Card(
                      child: ListTile(
                    title: Text('Пары отсутствуют',
                        style: Theme.of(context).textTheme.labelLarge),
                  )),
                );
              }
            },
            itemCount: daysOfWeek.length,
          ),
        ),
      ],
    );

    //   // } else {
    //     return Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 10),
    //       child: Column(
    //         children: [
    //           const SizedBox(
    //             height: 15.0,
    //           ),
    //           _buildDaysButtons(),
    //           const SizedBox(
    //             height: 15.0,
    //           ),

    //         ],
    //       ),
    //     );
    //   }
    // }
  }
}
