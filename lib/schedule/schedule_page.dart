import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

import 'package:ncti/schedule/widgets/schedule_widget_lesson.dart';

import 'models/day_model.dart';

@RoutePage()
class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  dynamic dataJson = '';
  bool isLoading = true;

  void gettingSched() async {
    debugPrint('До получения $isLoading');
    // AutoRouter.of(context).push(LoadingRoute());

    GetToken().getAccessToken().then((value) {
      String? result = value;
      if (result != null) {
        final jwtToken = Jwt.parseJwt(result);
        List<dynamic> roles = jwtToken['role'];
        List<String> authorities = [];
        for (var role in roles) {
          authorities.add(role['authority']);
        }

        // Получение расписания

        if (authorities.contains('ROLE_STUDENT')) {
          // debugPrint('Это Студент');
          GetScheduleRepositories().getStudentShedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
            debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          // debugPrint('Это преподаватель');
          GetScheduleRepositories().getTeacherShedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
            debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        }
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      gettingSched();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      List<Lesson> _getLessonsForDay(String day) {
        switch (day) {
          case 'Понедельник':
            if (dataJson.containsKey('Понедельник')) {
              return dataJson['Понедельник']!;
            } else {
              return [];
            }
          case 'Вторник':
            if (dataJson.containsKey('Вторник')) {
              return dataJson['Вторник']!;
            } else {
              return [];
            }
          case 'Среда':
            if (dataJson.containsKey('Среда')) {
              return dataJson['Среда']!;
            } else {
              return [];
            }
          case 'Четверг':
            if (dataJson.containsKey('Четверг')) {
              return dataJson['Четверг']!;
            } else {
              return [];
            }
          case 'Пятница':
            if (dataJson.containsKey('Пятница')) {
              return dataJson['Пятница']!;
            } else {
              return [];
            }
          case 'Суббота':
            if (dataJson.containsKey('Суббота')) {
              return dataJson['Суббота']!;
            } else {
              return [];
            }
          default:
            return [];
        }
      }

//TODO ДОБАВЬ КНОПКУ ОБНОВЛЕНИЯ РАСПИСАНИЯ
      List<Lesson> lessons = _getLessonsForDay(selectedDay);

      if (lessons.isEmpty) {
        return Scaffold(
            body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              _buildDaysButtons(),
              SizedBox(
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
                SizedBox(
                  height: 15.0,
                ),
                _buildDaysButtons(),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return LessonWidget(lesson: lessons[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // // debugPrint('JSON $jsonDec');
  }

  Widget _buildDaysButtons() {
    void onDaySelected(String day) {
      setState(() {
        selectedDay = day;
      });
    }

    return Container(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lessonsOfWeek.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              onPressed: () => onDaySelected(lessonsOfWeek[index]),
              child: Text(daysOfWeek[index]),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 15)),
                backgroundColor: selectedDay == lessonsOfWeek[index]
                    ? MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(65, 45, 166, 1))
                    : MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(241, 246, 252, 1)),
                foregroundColor: selectedDay == lessonsOfWeek[index]
                    ? MaterialStateProperty.all<Color>(Colors.white)
                    : MaterialStateProperty.all<Color>(
                        Color.fromRGBO(114, 108, 202, 1)),
              ),
            );

            // return Row(
            //   children: daysOfWeek.map((day) {
            //     return
            //   }).toList(),
            // );
          }),
    );
  }
}
