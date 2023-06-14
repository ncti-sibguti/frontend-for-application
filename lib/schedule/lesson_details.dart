import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:ncti/schedule/models/schedule_repository.dart';

import 'models/schedule_notes.dart';

@RoutePage()
class LessonDetailsPage extends StatefulWidget {
  final dynamic lesson;
  final DateTime day;
  final bool isTeacher;

  LessonDetailsPage(
      {required this.lesson, required this.day, required this.isTeacher});

  @override
  State<LessonDetailsPage> createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  List<Note> savedNotes = [];
  String newNote = '';
  final TextEditingController _classroomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScheduleNotes().loadNotes(widget.lesson.subject).then((value) {
      setState(() {
        savedNotes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.lesson.subject),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: ListView(children: [
            Text(
              '${widget.lesson.numberPair}-я пара',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Предмет: ${widget.lesson.subject}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.isTeacher
                  ? 'Группы: ${widget.lesson.groups.join(', ')}'
                  : widget.lesson.teachers
                      .map((e) => '${e.lastname} ${e.firstname} ${e.surname}')
                      .join(', \n'),
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                'Аудитория: ${widget.lesson.classroom}',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              trailing: widget.isTeacher
                  ? IconButton(
                      onPressed: () => _editClassroom(context),
                      icon: const Icon(Icons.edit_outlined))
                  : null,
            ),
            const SizedBox(height: 16.0),
            getScheduleItemByNumberPair(context, widget.lesson.numberPair),
            const SizedBox(height: 16.0),
            const Text(
              "Заметки:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: savedNotes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    savedNotes[index].note,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.background),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ScheduleNotes()
                        .deleteNotes(widget.lesson.subject, savedNotes[index]),
                  ),
                  leading: const Icon(Icons.notes_outlined),
                );
              },
            ),
            ListTile(
                title: Text(
                  'Добавить заметку',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                trailing: Icon(
                  Icons.add_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () => addNote(context))
          ]))),
    );
  }

  Future<dynamic> addNote(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Note> notes =
            List.from(savedNotes.map((note) => Note(note: note.note)));

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          elevation: 5.0,
          title: const Text('Добавить заметку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              TextField(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
                onChanged: (value) {
                  setState(() {
                    newNote = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Введите заметку...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
            TextButton(
              onPressed: () {
                notes.add(Note(note: newNote));
                _saveNotes(widget.lesson.subject, notes);
                Navigator.of(context).pop();
              },
              child: Text('Сохранить',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
            ),
          ],
        );
      },
    );
  }

  void _saveNotes(String subject, List<Note> notes) async {
    await ScheduleNotes().saveNotes(subject, notes);
    // Optionally, provide feedback to indicate that the notes have been saved
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String time,
    int id,
  ) {
    return ListTile(
      title: Text(
        time,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 20),
      ),
    );
  }

  Widget getScheduleItemByNumberPair(BuildContext context, int numberPair) {
    ScheduleNotes().loadNotes(widget.lesson.subject).then((value) {
      setState(() {
        savedNotes = value;
      });
    });

    switch (numberPair) {
      case 1:
        return _buildScheduleItem(
          context,
          '09:00 - 10:30',
          1,
        );
      case 2:
        return _buildScheduleItem(
          context,
          '10:45 - 12:20',
          2,
        );
      case 3:
        return _buildScheduleItem(
          context,
          '12:50 - 14:25',
          3,
        );
      case 4:
        return _buildScheduleItem(
          context,
          '14:30 - 15:55',
          4,
        );
      case 5:
        return _buildScheduleItem(
          context,
          '16:00 - 17:30',
          5,
        );
      default:
        return Container();
    }
  }

  void _editClassroom(BuildContext context) {
    String classroom = widget.lesson.classroom;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newClassroom =
            classroom; // Создайте новую переменную для изменяемого значения кабинета

        return AlertDialog(
          title: const Text('Изменить кабинет'),
          content: TextField(
            controller: _classroomController,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
            onChanged: (value) {
              newClassroom =
                  value; // Обновление нового значения кабинета при вводе в TextField
            },
            decoration: InputDecoration(
              labelText: 'Введите номер кабинета',
              hintText: 'Номер кабинета...',
              labelStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary), // Customize the label text style
              hintStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .background), // Customize the hint text style
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary), // Customize the border color
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary), // Customize the focused border color
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  classroom =
                      newClassroom; // Обновление значения кабинета после сохранения
                });

                GetScheduleRepositories().editClassroom(
                    widget.day,
                    widget.lesson.groups,
                    widget.lesson.subject,
                    widget.lesson.numberPair,
                    _classroomController);
                _classroomController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'Сохранить',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        );
      },
    );
  }
}
