import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TimeSchedulePage extends StatelessWidget {
  const TimeSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Расписание звонков'),
      ),
      body: ListView(
        children: [
          _buildScheduleItem('09:00 - 10:30', 1),
          _buildScheduleItem('10:45 - 12:20', 2),
          _buildScheduleItem('12:50 - 14:25', 3),
          _buildScheduleItem('14:30 - 15:55', 4),
          _buildScheduleItem('16:00 - 17:30', 5),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, int id) {
    return ListTile(
      title: Text(time),
      subtitle: Text('$id-я пара'),
      onTap: () {
        // Действие при нажатии на элемент расписания
      },
    );
  }
}
