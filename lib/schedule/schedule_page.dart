import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

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
    getSched();
  }

  dynamic dataJson = '';
  bool isLoading = true;
  List<String> role = [];

  void getSched() async {
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
          GetScheduleRepositories().getStudentSchedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          GetScheduleRepositories().getTeacherSchedule().then((data) {
            setState(() {
              isLoading = false;
              dataJson = data;
            });
          });
        }
      }
    });
  }

  Future<void> _refreshSchedule() async {
    getSched();
  }

  @override
  Widget build(BuildContext context) {
    var itemsActionBar = [
      SpeedDialChild(
        backgroundColor: Colors.greenAccent,
        onTap: _refreshSchedule,
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      SpeedDialChild(
        backgroundColor: Colors.indigoAccent,
        onTap: () {
          AutoRouter.of(context).push(ButtonRoute());
        },
        child: Icon(
          Icons.group_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ];

    return Scaffold(
        floatingActionButton: SpeedDial(
          overlayOpacity: 0,
          icon: Icons.arrow_upward_outlined,
          activeIcon: Icons.arrow_downward_outlined,
          foregroundColor: Theme.of(context).colorScheme.primary,
          children: itemsActionBar,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : role.contains('ROLE_TEACHER')
                ? RefreshIndicator(
                    onRefresh: _refreshSchedule,
                    child: TeacherDayWidget(dataJson: dataJson))
                : RefreshIndicator(
                    onRefresh: _refreshSchedule,
                    child: StudentDayWidget(dataJson: dataJson)));
  }
}
