import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/widgets/student_lesson_widget.dart';

@RoutePage()
class GroupLessonsPage extends StatefulWidget {
  const GroupLessonsPage({required this.group});

  final ScheduleGroup group;

  @override
  State<GroupLessonsPage> createState() => _GroupLessonsPageState();
}

class _GroupLessonsPageState extends State<GroupLessonsPage> {
  dynamic dataJson;
  bool isLoading = true;
  String? selectedDay;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetScheduleRepositories()
        .getScheduleGroup(widget.group.id.toString())
        .then((data) {
      setState(() {
        dataJson = data;
        isLoading = false;
      });
    });
  }

  static List<String> daysOfWeek = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"];
  List<dynamic> getLessonsForDay(int day) {
    String dayOfWeek = daysOfWeek[day];
    if (dataJson.containsKey(dayOfWeek)) {
      return dataJson[dayOfWeek];
    } else {
      return [];
    }
  }

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

  List<dynamic> _getLessonsForDay(int day) {
    String dayOfWeek = daysOfWeek[day];
    if (dataJson.containsKey(dayOfWeek)) {
      return dataJson[dayOfWeek];
    } else {
      return [];
    }
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
                SizedBox(
                    height: 40,
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daysOfWeek.length,
                        itemBuilder: (context, int pageIndex) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width *
                                1 /
                                daysOfWeek.length,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateColor.resolveWith((states) {
                                  return selectedDay == daysOfWeek[pageIndex]
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.primary;
                                }),
                                foregroundColor:
                                    MaterialStateColor.resolveWith((states) {
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
                    )),
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
                          DateFormat.yMMMMEEEEd().format(day);

                      if (lessons.isNotEmpty) {
                        return Column(
                          children: [
                            Text(formattedDate),
                            Expanded(
                              child: ListView.builder(
                                itemCount: lessons.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return StudentLessonWidget(
                                      lesson: lessons[index], day: day);
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
