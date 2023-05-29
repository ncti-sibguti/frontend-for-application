import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/widgets/schedule_student_lessons.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : StudentDayWidget(dataJson: dataJson),
    );
  }
}
