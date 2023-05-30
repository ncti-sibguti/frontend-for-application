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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Список групп'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 4, // Количество колонок
          children: groups.map((group) {
            return Padding(
              padding: EdgeInsets.all(8.0), // Отступы между кнопками
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context)
                          .colorScheme
                          .secondary), // Цвет фона кнопки
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context)
                          .colorScheme
                          .primary), // Цвет текста кнопки
                ),
                onPressed: () {
                  AutoRouter.of(context).push(GroupLessonsRoute(group: group));
                },
                child: Text(group.name),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
