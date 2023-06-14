import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/chat/chat_repository.dart';
import 'package:ncti/maps/model/student.dart';
import 'Window/create_group_chat.dart';
import '/repository/ncti_repository.dart';

import '../routes/router.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? accessToken;
  String? id;
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingChats = false;
  List<User> users = [];
  List<Group> chats = [];

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

  Future<void> _refreshChatList() async {
    setState(() {
      _isFetchingChats = true;
    });

    await GetChat().getChats().then((data) {
      setState(() {
        chats = data;
        _isFetchingChats = false;
      });
    });
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshChatList,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: chats.length,
          itemBuilder: (context, index) {
            return ListTile(
              minVerticalPadding: 20,
              leading: Icon(
                chats[index].type == "PUBLIC"
                    ? Icons.groups_2_outlined
                    : Icons.person_2_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.background,
              ),
              title: Text(
                chats[index].name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              subtitle: chats[index].type == "PUBLIC"
                  ? Text('Групповой чат')
                  : Text('Личный чат'),
              onTap: () {
                if (chats[index].type == "PUBLIC") {
                  AutoRouter.of(context).push(
                    PublicChatRoute(
                      chatId: chats[index].id,
                      group: chats[index],
                    ),
                  );
                }
                if (chats[index].type == "PRIVATE") {
                  AutoRouter.of(context).push(PrivateChatRoute(
                    chatId: chats[index].id,
                    group: chats[index],
                  ));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoaderIndicator() {
    return _isFetchingChats
        ? CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )
        : Container();
  }

  void _openCreateGroupChatModal(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CreateGroupChatModal(
          onChatCreated: _refreshChatList,
        );
      },
    );
  }
}
