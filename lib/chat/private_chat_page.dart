import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:ncti/routes/router.dart';

import '../repository/ncti_repository.dart';

@RoutePage()
class PersonalyChatPage extends StatefulWidget {
  const PersonalyChatPage(
      {super.key,
      @PathParam('chatId') required this.chatId,
      required this.user});
  final int chatId;
  final User user;

  @override
  State<PersonalyChatPage> createState() => _PersonalyChatPageState();
}

class _PersonalyChatPageState extends State<PersonalyChatPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as PersonalyChatRouteArgs?;
    final chatId = args?.chatId;
    final user = args?.user;

    // final _user = types.User(id: userId.toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('${user?.firstName} ${user?.lastName}'),
        ),
        body: Center(child: Text('ты в чате, вот chat id $chatId')));
  }
}
