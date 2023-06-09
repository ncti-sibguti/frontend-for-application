import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({required this.title, required this.description, required this.date});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),
      );
}

class EventStorage {
  static const _eventsKey = 'events';

  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonEvents = prefs.getStringList(_eventsKey);
    if (jsonEvents != null) {
      return jsonEvents
          .map((json) => Event.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> saveEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonEvent = jsonEncode(event.toJson());

    final jsonEvents = prefs.getStringList(_eventsKey) ?? [];

    jsonEvents.add(jsonEvent);

    await prefs.setStringList(_eventsKey, jsonEvents);
    debugPrint('событие ${event.date} ${event.title} записано');
  }

  Future<void> removeEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonEvents = prefs.getStringList(_eventsKey) ?? [];
    jsonEvents.removeWhere(
        (json) => jsonDecode(json)['date'] == event.date.toIso8601String());
    await prefs.setStringList(_eventsKey, jsonEvents);
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
