import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/chat/add_user_chat.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:ncti/theme.dart';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class PublicChatPage extends StatefulWidget {
  const PublicChatPage(
      {super.key,
      @PathParam('chatId') required this.chatId,
      required this.group,
      required this.accessToken,
      required this.id});
  final String chatId;
  final Group group;
  final String accessToken;
  final String id;

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  List<types.Message> _messages = [];

  StompClient? stompClient;
  String? accessToken;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    GetChat().getMessages(widget.chatId).then((value) {
      setState(() {
        _messages = value;
      });
    });
  }

  @override
  void dispose() {
    disconnectFromWebSocket();
    super.dispose();
  }

  void connectToWebSocket() async {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://94.154.11.150:8080/api/ws',
        onConnect: (StompFrame connectFrame) {
          setState(() {
            isLoading = false;
          });
          debugPrint('Connected to WebSocket');
          subscribeToChatTopic();
        },
        onWebSocketError: (dynamic error) {
          debugPrint('WebSocket error: $error');
        },
      ),
    );

    stompClient?.activate();
  }

  void disconnectFromWebSocket() {
    stompClient?.deactivate();
  }

  void subscribeToChatTopic() {
    stompClient?.subscribe(
      destination: '/topic/chats/${widget.chatId}',
      callback: (StompFrame frame) {
        final messages = types.TextMessage.fromJson(jsonDecode(frame.body!));
        setState(() {
          _messages.insert(0, messages);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final _user = types.User(id: userId.toString());

    return Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(Icons.more_horiz_outlined),
                onChanged: (value) {
                  if (value == 'Выход из чата') {
                    GetChat().deleteChat(widget.chatId);
                  }
                  if (value == 'Добавить участников') {
                    _openAddGroupChatModal(context);
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'Выход из чата',
                    child: Text(
                      'Выход из чата',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Добавить участников',
                    child: Text(
                      'Добавить участников',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(widget.group.name),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Chat(
                  l10n: const ChatL10nRu(),
                  showUserAvatars: true,
                  showUserNames: true,
                  messages: _messages,
                  dateLocale: 'ru_RU',
                  onSendPressed: _sendMessage,
                  user: types.User(id: widget.id),
                  theme: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.chatDark
                      : AppTheme.chatLight,
                ),
              ));
  }

  void _sendMessage(types.PartialText message) {
    // final user = types.User(id: widget.id);
    // final textMessage = types.TextMessage(
    //   id: const Uuid().v4(),
    //   text: message.text,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   author: user,
    // );

    stompClient?.send(
      destination: '/chats/${widget.chatId}',
      body: jsonEncode({"senderId": widget.id, "text": message.text}),
      headers: {},
    );

    // GetChat().postMessage(textMessage.text, widget.chatId);
  }

  void _openAddGroupChatModal(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddUserChat(chatId: widget.chatId);
      },
    );
  }
}
