import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/repository/ncti_repository.dart';

import 'package:ncti/schedule/widgets/schedule_student_lessons.dart';
import 'package:ncti/schedule/widgets/schedule_teacher_lessons.dart';

@RoutePage()
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingSched();
  }

  static List<String> lessonsOfWeek = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота"
  ];

  dynamic dataJson = '';
  bool isLoading = true;
  List<String> role = [];
  String selectedDay = lessonsOfWeek[DateTime.now().weekday - 1];

  void gettingSched() async {
    GetToken().getAccessToken().then((value) {
      String? result = value;
      if (result != null) {
        final jwtToken = Jwt.parseJwt(result);
        List<dynamic> roles = jwtToken['role'];
        List<String> authorities = [];
        for (var role in roles) {
          authorities.add(role['authority']);
        }

        setState(() {
          role = authorities;
        });

        // Получение расписания

        if (authorities.contains('ROLE_STUDENT')) {
          // debugPrint('Это Студент');
          GetScheduleRepositories().getStudentShedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          // debugPrint('Это преподаватель');
          GetScheduleRepositories().getTeacherShedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (role.contains('ROLE_TEACHER')) {
        return TeacherDayWidget(
          dataJson: dataJson,
        );
      } else if (role.contains('ROLE_STUDENT')) {
        return StudentDayWidget(dataJson: dataJson);
      } else {
        return const Scaffold(
            body: Center(
          child: Text('Произошла ошибка'),
        ));
      }
    }
  }
}
