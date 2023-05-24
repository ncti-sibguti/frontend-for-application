import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/chat/create_group_chat.dart';
import 'package:ncti/repository/ncti_repository.dart';

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
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: chats.length + 1,
          itemBuilder: (context, index) {
            if (index == chats.length) {
              return _buildLoaderIndicator(); // Placeholder for loader indicator at the end of the list
            } else {
              return ListTile(
                leading: Icon(
                  Icons.groups_2_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.background,
                ),
                title: Text(
                  chats[index].name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                subtitle: Text('Участников: ${chats[index].userCount}'),
                onTap: () {
                  AutoRouter.of(context).push(
                    PublicChatRoute(
                      chatId: chats[index].id,
                      group: chats[index],
                      accessToken: accessToken!,
                      id: id!,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoaderIndicator() {
    return _isFetchingChats
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
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
