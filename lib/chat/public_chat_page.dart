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
import 'package:stomp_dart_client/stomp_handler.dart';

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

  StompUnsubscribe? unsubscribe;
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

  void connectToWebSocket() async {
    // String? accessToken = await GetToken().getAccessToken();

    stompClient = StompClient(
      config: StompConfig.SockJS(
        //TODO раскоменти при релизе
        // stompConnectHeaders: ,
        // webSocketConnectHeaders: {
        //   'Content-type': 'application/json',
        //   'Authorization': 'Bearer $accessToken'
        // },
        url: 'http://94.154.11.150:8080/api/ws',
        onConnect: (StompFrame connectFrame) {
          setState(() {
            isLoading = false;
          });
          debugPrint('Connected to WebSocket');
          unsubscribe = stompClient!.subscribe(
            destination: '/topic/chats/${widget.chatId}',
            callback: (StompFrame frame) {
              final messages =
                  types.TextMessage.fromJson(jsonDecode(frame.body!));
              setState(() {
                _messages.insert(0, messages);
              });
              // Обработка полученного события
              print(frame.body);
            },
          );
        },
        onWebSocketError: (dynamic error) {
          debugPrint('WebSocket error: ${error.toString()}');
        },
        onDisconnect: (p0) => debugPrint(p0.body),
      ),
    );
    stompClient?.activate();
  }

  // void subscribeToChatTopic() {
  //   stompClient?.subscribe(
  //     destination: '/topic/chats/${widget.chatId}',
  //     callback: (StompFrame frame) {
  //       final messages = types.TextMessage.fromJson(jsonDecode(frame.body!));
  //       setState(() {
  //         _messages.insert(0, messages);
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
    stompClient?.send(
      destination: '/chats/${widget.chatId}',
      body: jsonEncode({"senderId": widget.id, "text": message.text}),
      headers: {},
    );
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

  @override
  void dispose() {
    disconnectFromWebSocket();
    super.dispose();
  }

  void disconnectFromWebSocket() {
    debugPrint('disconnect');

    // Вызов функции отписки
    unsubscribe!();
    stompClient?.deactivate();
  }
}
