import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncti/schedule/models/schedule_repository.dart';

import '/repository/ncti_repository.dart';
import '/schedule/widgets/lesson_widget.dart';

@RoutePage()
class GroupLessonsPage extends StatefulWidget {
  const GroupLessonsPage({required this.group});

  final ScheduleGroup group;

  @override
  State<GroupLessonsPage> createState() => _GroupLessonsPageState();
}

class _GroupLessonsPageState extends State<GroupLessonsPage> {
  @override
  void initState() {
    super.initState();

    getSched();
  }

  dynamic dataJson = '';
  bool isLoading = true;
  List<String> role = [];

  void getSched() async {
    GetScheduleRepositories()
        .getScheduleGroup(widget.group.id.toString())
        .then((data) {
      setState(() {
        dataJson = data;
      });
      scanDay();
      setState(() {
        selectedDay = daysOfWeek[weekdayInt];
        isLoading = false;
      });
    });
  }

  Future<void> _refreshSchedule() async {
    getSched();
  }

//TODO Экран по камерой
  static List<String> daysOfWeek = [];
  static List<String> weekdays = [];

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

  void scanDay() {
    if (dataJson.containsKey('Понедельник') &&
        !weekdays.contains('Понедельник')) {
      weekdays.add('Понедельник');
      daysOfWeek.add('ПН');
    }
    if (dataJson.containsKey('Вторник') && !weekdays.contains('Вторник')) {
      weekdays.add('Вторник');
      daysOfWeek.add('ВТ');
    }
    if (dataJson.containsKey('Среда') && !weekdays.contains('Среда')) {
      weekdays.add('Среда');
      daysOfWeek.add('СР');
    }
    if (dataJson.containsKey('Четверг') && !weekdays.contains('Четверг')) {
      weekdays.add('Четверг');
      daysOfWeek.add('ЧТ');
    }
    if (dataJson.containsKey('Пятница') && !weekdays.contains('Пятница')) {
      weekdays.add('Пятница');
      daysOfWeek.add('ПТ');
    }
    if (dataJson.containsKey('Суббота') && !weekdays.contains('Суббота')) {
      weekdays.add('Суббота');
      daysOfWeek.add('СБ');
    }
    debugPrint(weekdays.toString());
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.group.name),
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
                                    isTeacher: false,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        debugPrint(lessons.toString());
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
