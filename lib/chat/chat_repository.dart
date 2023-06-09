import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ncti/repository/ncti_repository.dart';

class Group {
  String id;
  String name;
  String type;

  Group({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

List<Group> parseGroups(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Group>((json) => Group.fromJson(json)).toList();
}

class GetChat {
  Future getChats() async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/chats";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final res = parseGroups(responseBody);
      return res;
    } else {
      throw Exception('failed to load chat');
    }
  }

  Future getMessages(String chatId, String type) async {
    String? accessToken = await GetToken().getAccessToken();
    String url = "$SERVER/chats/$chatId?type=$type";
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final messages = (jsonDecode(responseBody) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();

      return messages;
    } else {
      throw Exception('failed to load chat');
    }
  }

  Future createChat(String name, List<int> selectedUser) async {
    String? accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$SERVER/chats/create-public');
    final response = await http.post(
      url,
      body: jsonEncode({"name": name, "ids": selectedUser}),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    return response.body;
  }

  Future deleteChat(
    String chatId,
  ) async {
    String? accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$SERVER/chats/$chatId/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
  }

  Future addUserToChat(String chatId, List<int> selectedIds) async {
    String? accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$SERVER/chats/$chatId');
    final response = await http.post(url,
        body: jsonEncode({"ids": selectedIds}),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        });
    debugPrint(response.body);
  }
}
