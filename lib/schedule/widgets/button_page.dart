import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

@RoutePage()
class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  List<ScheduleGroup> groups = [];
  dynamic dataJson = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser().getAllGroup().then((data) {
      setState(() {
        groups = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список групп'),
      ),
      body: ListView(
        children: groups.map((group) {
          return ElevatedButton(
            child: Text(group.name),
            onPressed: () {
              AutoRouter.of(context).push(GroupLessonsRoute(group: group));
            },
          );
        }).toList(),
      ),
    );
  }
}
