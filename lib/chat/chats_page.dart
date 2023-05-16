import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/chat/create_group_chat.dart';
import 'package:ncti/chat/user_list_modal.dart';
import 'package:ncti/repository/ncti_repository.dart';

import '../routes/router.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    gettingChat();
    gettingUser();
  }

  List<User> users = [];
  List<Group> chats = [];
  void gettingChat() {
    GetChat().getChats().then((data) {
      setState(() {
        chats = data;
      });
    });
  }

  void gettingUser() {
    GetUser().getAllUser().then((data) {
      setState(() {
        users = data;
      });
    });
  }

  // void _showUserListModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       debugPrint(users.toString());
  //       return UserListModal(
  //         users: users,
  //         onUserSelected: (User user) {
  //           // AutoRouter.of(context).push(PersonalyChatRoute(
  //           //     userId: user.id.toString())); // Handle selected user
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.pending_actions),
          onPressed: () {
            _openCreateGroupChatModal(context);
          },
        ),
        body: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) => ListTile(
                title: Text(
                  chats[index].name,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text('Участников: ${chats[index].userCount}'),
                onTap: () {
                  // if (chats[index].type == 'PRIVATE') {
                  //   AutoRouter.of(context).push(PersonalyChatRoute(
                  //       chatId: chats[index].id, user: users[index]));
                  // } else {
                  AutoRouter.of(context).push(PublicChatRoute(
                      chatId: chats[index].id, group: chats[index]));
                  // }
                })));
  }
}

void _openCreateGroupChatModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return CreateGroupChatModal();
    },
  );
}
