import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:ncti/routes/router.dart';

import '../repository/ncti_repository.dart';

@RoutePage()
class PublicChatPage extends StatefulWidget {
  const PublicChatPage(
      {super.key,
      @PathParam('chatId') required this.chatId,
      required this.group});
  final int chatId;
  final Group group;

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: "3");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetChat().getMessages(widget.chatId).then((value) {
      // debugPrint(value.toString());
      setState(() {
        _messages = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as PublicChatRouteArgs?;
    final chatId = args?.chatId;
    final group = args?.group;
    debugPrint(_messages.toString());

    // final _user = types.User(id: userId.toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('${group?.name}'),
        ),
        body: Chat(
            showUserAvatars: true,
            showUserNames: true,
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user));
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "3",
      text: message.text,
    );
    GetChat().postMessage(
      textMessage.text,
      widget.chatId,
    );
    _addMessage(textMessage);
  }
}
