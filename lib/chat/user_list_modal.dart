import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

class UserListModal extends StatelessWidget {
  final List<User> users;
  final ValueChanged<User> onUserSelected;

  const UserListModal(
      {Key? key, required this.users, required this.onUserSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Выбери собеседника'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          if (user.username == 'admin') {
            debugPrint('админ');
          }
          return ListTile(
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onTap: () {
              AutoRouter.of(context)
                  .push(PersonalyChatRoute(chatId: user.id, user: user));
            },
          );
        },
      ),
    );
  }
}
