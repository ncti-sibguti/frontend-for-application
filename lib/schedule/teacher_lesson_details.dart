import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/teacher_schedule.dart';

@RoutePage()
class TeacherLessonDetailsPage extends StatefulWidget {
  final TeacherLesson lesson;

  TeacherLessonDetailsPage({required this.lesson});

  @override
  State<TeacherLessonDetailsPage> createState() =>
      _TeacherLessonDetailsPageState();
}

class Note {
  final String note;

  Note({required this.note});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
    };
  }
}

class _TeacherLessonDetailsPageState extends State<TeacherLessonDetailsPage> {
  List<Note> savedNotes = [];
  final TextEditingController _classroomController = TextEditingController();
  String newNote = '';
  @override
  void initState() {
    super.initState();
    loadNotes(widget.lesson.subject).then((value) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.lesson.numberPair}-я пара',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Предмет: ${widget.lesson.subject}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.lesson.groups.join(', '),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    'Аудитория: ${widget.lesson.classroom}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  // IconButton(
                  //     onPressed: () => _editClassroom(context),
                  //     icon: Icon(Icons.edit_outlined))
                ],
              ),
              const SizedBox(height: 16.0),
              getScheduleItemByNumberPair(context, widget.lesson.numberPair),
              const SizedBox(height: 16.0),
              Text(
                "Заметки по ${widget.lesson.subject}:",
                style: const TextStyle(fontSize: 18),
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
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    leading: const Icon(Icons.delete_outline),
                    onTap: () =>
                        deleteNotes(widget.lesson.subject, savedNotes[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              List<Note> notes =
                  List.from(savedNotes.map((note) => Note(note: note.note)));

              return AlertDialog(
                title: Text('Добавить заметки для ${widget.lesson.subject}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16.0),
                    TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
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
        },
      ),
    );
  }

  Future<void> saveNotes(String subject, List<Note> notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesJson = jsonEncode(
        notes.map((note) => Note(note: note.note).toJson()).toList());
    await prefs.setString('notes_$subject', notesJson);
  }

  Future<List<Note>> loadNotes(String subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesJson = prefs.getString('notes_$subject') ?? '[]';
    List<dynamic> notesList = jsonDecode(notesJson);
    List<Note> notes = notesList
        .cast<Map<String, dynamic>>()
        .map<Note>((json) => Note.fromJson(json))
        .toList();

    return notes;
  }

  void deleteNotes(String subject, Note note) async {
    List<Note> notes =
        await loadNotes(subject); // Загрузка текущего списка заметок
    notes.removeWhere((element) =>
        element.note == note.note); // Удаление нужной заметки из списка
    await saveNotes(subject, notes); // Сохранение обновленного списка заметок
  }

  void _saveNotes(String subject, List<Note> notes) async {
    await saveNotes(subject, notes);
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
      onTap: () {},
    );
  }

  Widget getScheduleItemByNumberPair(BuildContext context, int numberPair) {
    loadNotes(widget.lesson.subject).then((value) {
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
          title: Text('Изменить кабинет'),
          content: TextField(
            controller: _classroomController,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
            onChanged: (value) {
              newClassroom =
                  value; // Обновление нового значения кабинета при вводе в TextField
            },
            decoration: InputDecoration(
              hintText: 'Введите новый кабинет...',
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
                debugPrint(classroom);
                GetScheduleRepositories().editClassroom(
                    widget.lesson.groups,
                    widget.lesson.subject,
                    widget.lesson.numberPair,
                    _classroomController);
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
