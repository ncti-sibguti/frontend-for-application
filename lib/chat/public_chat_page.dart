import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/chat/chat_repository.dart';

import 'Window/add_user_chat.dart';
import '/repository/ncti_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '/theme.dart';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

@RoutePage()
class PublicChatPage extends StatefulWidget {
  const PublicChatPage({
    super.key,
    @PathParam('chatId') required this.chatId,
    required this.group,
  });
  final String chatId;
  final Group group;

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  List<types.Message> _messages = [];

  String? id;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    connectToWebSocket(widget.chatId);
    GetChat().getMessages(widget.chatId, widget.group.type).then((value) {
      setState(() {
        _messages = value;
      });
    });
    GetToken().getAccessToken().then((value) {
      final jwtToken = Jwt.parseJwt(value!);
      int _id = jwtToken['user_id'];
      setState(() {
        id = _id.toString();
      });
    });
  }

  StompUnsubscribe? unsubscribe;
  StompClient? stompClient;

  void connectToWebSocket(String chatId) async {
    String? accessToken = await GetToken().getAccessToken();

    stompClient = StompClient(
      config: StompConfig.SockJS(
        webSocketConnectHeaders: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        url: '${dotenv.get('SERVER')}/ws',
        onConnect: (StompFrame connectFrame) {
          setState(() {
            isLoading = false;
          });
          debugPrint('Connected to WebSocket');
          unsubscribe = stompClient!.subscribe(
            destination: '/topic/public/$chatId',
            callback: (StompFrame frame) {
              final messages =
                  types.TextMessage.fromJson(jsonDecode(frame.body!));
              setState(() {
                _messages.insert(0, messages);
              });
              // Обработка полученного события
              debugPrint(frame.body);
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

  void disconnectFromWebSocket() {
    debugPrint('disconnect');

    // Вызов функции отписки
    unsubscribe!();
    stompClient?.deactivate();
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
            Container(
              width: MediaQuery.of(context).size.width /
                  4, // Установите ширину в 1/4 экрана
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  padding: EdgeInsets.only(right: 15),
                  icon: Icon(Icons.more_horiz_outlined, color: Colors.white),
                  isExpanded:
                      true, // Занимает все доступное горизонтальное пространство
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
                  user: types.User(id: id!),
                  theme: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.chatDark
                      : AppTheme.chatLight,
                ),
              ));
  }

  void _sendMessage(types.PartialText message) {
    stompClient?.send(
      destination: '/chats/${widget.chatId}/chat',
      body: jsonEncode({"text": message.text}),
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
}
