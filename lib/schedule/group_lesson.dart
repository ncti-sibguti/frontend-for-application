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
  static List<String> _daysOfWeek = [];
  static List<String> _weekdays = [];

  void getSched() async {
    GetScheduleRepositories()
        .getScheduleGroup(widget.group.id.toString())
        .then((data) {
      setState(() {
        dataJson = data;
      });

      scanDay();
      setState(() {
        selectedDay = _daysOfWeek[weekdayInt];
        isLoading = false;
      });
    });
  }

  Future<void> _refreshSchedule() async {
    getSched();
  }

//TODO Экран по камерой

  static int weekdayInt = 0;
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
        !_weekdays.contains('Понедельник')) {
      _weekdays.add('Понедельник');
      _daysOfWeek.add('ПН');
    }
    if (dataJson.containsKey('Вторник') && !_weekdays.contains('Вторник')) {
      _weekdays.add('Вторник');
      _daysOfWeek.add('ВТ');
    }
    if (dataJson.containsKey('Среда') && !_weekdays.contains('Среда')) {
      _weekdays.add('Среда');
      _daysOfWeek.add('СР');
    }
    if (dataJson.containsKey('Четверг') && !_weekdays.contains('Четверг')) {
      _weekdays.add('Четверг');
      _daysOfWeek.add('ЧТ');
    }
    if (dataJson.containsKey('Пятница') && !_weekdays.contains('Пятница')) {
      _weekdays.add('Пятница');
      _daysOfWeek.add('ПТ');
    }
    if (dataJson.containsKey('Суббота') && !_weekdays.contains('Суббота')) {
      _weekdays.add('Суббота');
      _daysOfWeek.add('СБ');
    }
    debugPrint(_weekdays.toString());
  }

  List<dynamic> getLessonsForDay(int day) {
    String dayOfWeek = _weekdays[day];
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
        itemCount: _daysOfWeek.length,
        itemBuilder: (context, int pageIndex) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 1 / _daysOfWeek.length,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) {
                  return selectedDay == _daysOfWeek[pageIndex]
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary;
                }),
                foregroundColor: MaterialStateColor.resolveWith((states) {
                  return selectedDay == _daysOfWeek[pageIndex]
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary;
                }),
              ),
              onPressed: () {
                setState(() {
                  _pageController.jumpToPage(pageIndex);
                });
              },
              child: Text(_daysOfWeek[pageIndex]),
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
                        onDaySelected(_daysOfWeek[pageIndex]),
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
                    itemCount: _daysOfWeek.length,
                  ),
                ),
              ],
            ),
    );
  }
}
