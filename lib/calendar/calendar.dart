// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'model/calendar_model.dart';

@RoutePage()
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Map<DateTime, List<Event>> _events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late TextEditingController _eventTitleController;
  late TextEditingController _eventDescriptionController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _eventTitleController = TextEditingController();
    _eventDescriptionController = TextEditingController();
    // _events = {};

    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier<List<Event>>([]);
    EventStorage().loadEvents().then((events) {
      setState(() {
        for (final event in events) {
          final date = event.date;
          _events[date] = [..._events[date] ?? [], event];
          debugPrint(_events[date].toString());
        }
      });
    });
  }

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(focusedDay);
      });
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить заметку'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  controller: _eventTitleController,
                  decoration: InputDecoration(
                    hintText: 'Введите название',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  controller: _eventDescriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Введите текст',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Отмена',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
              onPressed: () {
                AutoRouter.of(context).pop();
                _eventTitleController.clear();
                _eventDescriptionController.clear();
              },
            ),
            TextButton(
              child: Text(
                'Добавить',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
              onPressed: () {
                final title = _eventTitleController.text;
                final description = _eventDescriptionController.text;
                final event = Event(
                    title: title, description: description, date: _focusedDay);
                setState(() {
                  _events[event.date] = [..._events[event.date] ?? [], event];
                });
                EventStorage().saveEvent(event);

                AutoRouter.of(context).pop();
                _eventTitleController.clear();
                _eventDescriptionController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void _showViewDialog(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.title,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.background)),
          content: Text(
            event.description,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
          actions: [
            TextButton(
              child: Text('Отмена',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
              onPressed: () {
                AutoRouter.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Удалить',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
              onPressed: () {
                setState(() {
                  _events[_selectedDay]!.remove(event);
                });
                EventStorage().removeEvent(event);
                AutoRouter.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Календарь'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              availableCalendarFormats: const {
                CalendarFormat.month: 'Месяц',
                // CalendarFormat.week: 'Неделя'
              },
              locale: "ru_RU",
              startingDayOfWeek: StartingDayOfWeek.monday,
              weekNumbersVisible: true,
              calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle)),
              calendarFormat: _calendarFormat,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _selectedDay!,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Заметки на ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            _buildEventList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _showAddDialog,
        tooltip: 'Добавить заметку',
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (_events[_selectedDay] != null && _events[_selectedDay]!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _events[_selectedDay]!.length,
        itemBuilder: (BuildContext context, int index) {
          final event = _events[_selectedDay]![index];
          return ListTile(
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(event.description),
            trailing: const Icon(Icons.delete_outline),
            onTap: () => _showViewDialog(event),
          );
        },
      );
    } else {
      return const Center(
        child: Text('Заметки не найдены'),
      );
    }
  }
}
