import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

class ScheduleNotes {
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
    List<Note> notes = await loadNotes(subject);

    // Загрузка текущего списка заметок
    notes.removeWhere((element) => element.note == note.note);
    // Удаление нужной заметки из списка
    await saveNotes(subject, notes); // Сохранение обновленного списка заметок
  }
}
