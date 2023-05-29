import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TimeSchedulePage extends StatelessWidget {
  const TimeSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание звонков'),
      ),
      body: ListView(
        children: [
          _buildScheduleItem('09:00 - 10:30', '1-я пара'),
          _buildScheduleItem('10:45 - 12:20', '2-я пара'),
          _buildScheduleItem('12:50 - 14:25', '3-я пара'),
          _buildScheduleItem('14:30 - 15:55', '4-я пара'),
          _buildScheduleItem('16:00 - 17:30', '5-я пара'),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String subject) {
    return ListTile(
      title: Text(time),
      subtitle: Text(subject),
      onTap: () {
        // Действие при нажатии на элемент расписания
      },
    );
  }
}
