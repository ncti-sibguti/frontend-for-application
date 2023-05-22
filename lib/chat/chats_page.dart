import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
  String? accessToken;
  String? id;
  @override
  void initState() {
    super.initState();
    gettingChat();
    gettingUser();
    GetToken().getAccessToken().then((value) {
      final jwtToken = Jwt.parseJwt(value!);
      int _id = jwtToken['user_id'];
      setState(() {
        id = _id.toString();
        accessToken = value;
      });
    });
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
          child: Icon(
            Icons.create_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            _openCreateGroupChatModal(context);
          },
        ),
        body: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      // Цвет фона элемента списка

                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background)) // Закругление углов
                      ),
                  child: ListTile(
                      leading: Icon(
                        Icons.groups_3_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      title: Text(
                        chats[index].name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                      subtitle: Text('Участников: ${chats[index].userCount}'),
                      onTap: () {
                        // if (chats[index].type == 'PRIVATE') {
                        //   AutoRouter.of(context).push(PersonalyChatRoute(
                        //       chatId: chats[index].id, user: users[index]));
                        // } else {
                        AutoRouter.of(context).push(PublicChatRoute(
                            chatId: chats[index].id,
                            group: chats[index],
                            accessToken: accessToken!,
                            id: id!));

                        // }
                      }),
                )));
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
