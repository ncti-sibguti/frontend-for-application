import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  WebSocketChannel? _channel;
  String? accessToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetChat().getMessages(widget.chatId).then((value) {
      setState(() {
        _messages = value;
      });
    });
    debugPrint(_messages.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = types.User(id: widget.id);
    // final _user = types.User(id: userId.toString());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('${widget.group.name}'),
        ),
        body: Chat(
            l10n: ChatL10nRu(),
            showUserAvatars: true,
            showUserNames: true,
            messages: _messages,
            onSendPressed: _sendMessage,
            user: user));
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _sendMessage(types.PartialText message) {
    final user = types.User(id: widget.id);
    final textMessage = types.TextMessage(
      id: '3',
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      author: user,
    );

    _addMessage(textMessage);
    GetChat().postMessage(textMessage.text, widget.chatId);
  }
}
