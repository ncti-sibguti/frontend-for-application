import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/schedule/models/schedule_repository.dart';
import 'package:ncti/schedule/widgets/lesson_widget.dart';
import '/repository/ncti_repository.dart';
import '/routes/router.dart';

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
    super.initState();
    setState(() {
      selectedDay = daysOfWeek[weekdayInt];
    });
    getSched();
  }

  dynamic dataJson = '';
  bool isLoading = true;
  bool isTeacher = false;
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
            if (!mounted) return;
            setState(() {
              isLoading = false;
              dataJson = data;
              isTeacher = false;
            });
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          GetScheduleRepositories().getTeacherSchedule().then((data) {
            if (!mounted) return;
            setState(() {
              isLoading = false;
              dataJson = data;
              isTeacher = true;
            });
          });
        }
      }
    });
  }

  Future<void> _refreshSchedule() async {
    getSched();
  }

  static List<String> daysOfWeek = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"];
  static List<String> weekdays = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота"
  ];

  static int weekdayInt = (DateTime.now().weekday - 1);
  String? selectedDay;
  final PageController _pageController =
      PageController(initialPage: weekdayInt);

  DateTime getDateTimeForDayOfWeek(int dayOfWeek) {
    DateTime currentDate = DateTime.now();
    int difference = dayOfWeek - currentDate.weekday;
    DateTime desiredDate = currentDate.add(Duration(days: difference));
    return desiredDate;
  }

  void onDaySelected(String day) {
    setState(() {
      selectedDay = day;
    });
  }

  List<dynamic> getLessonsForDay(int day) {
    String dayOfWeek = weekdays[day];
    if (dataJson.containsKey(dayOfWeek)) {
      return dataJson[dayOfWeek];
    } else {
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
                  _pageController.jumpToPage(pageIndex);
                });
              },
              child: Text(daysOfWeek[pageIndex]),
            ),
          );
        },
      ),
    );
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
          AutoRouter.of(context).push(const ButtonRoute());
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
          : Column(
              children: [
                const SizedBox(height: 8.0),
                SizedBox(height: 40, child: _buildDaysButtons()),
                const SizedBox(height: 16.0),
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (int pageIndex) =>
                        onDaySelected(daysOfWeek[pageIndex]),
                    controller: _pageController,
                    itemBuilder: (context, pageIndex) {
                      DateTime day = getDateTimeForDayOfWeek(pageIndex + 1);
                      List<dynamic> lessons = getLessonsForDay(pageIndex);
                      String formattedDate =
                          DateFormat.yMMMMEEEEd('ru_RU').format(day);

                      if (lessons.isNotEmpty) {
                        return Column(
                          children: [
                            Text(formattedDate),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: lessons.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return LessonWidget(
                                      lesson: lessons[index],
                                      day: day,
                                      isTeacher: isTeacher);
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Card(
                            child: ListTile(
                              title: Text('Пары отсутствуют',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: daysOfWeek.length,
                  ),
                ),
              ],
            ),
    );
  }
}
