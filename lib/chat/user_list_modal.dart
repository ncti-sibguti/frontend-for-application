import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

class UserListModal extends StatefulWidget {
  final List<User> users;
  final ValueChanged<User> onUserSelected;

  const UserListModal({
    Key? key,
    required this.users,
    required this.onUserSelected,
  }) : super(key: key);

  @override
  _UserListModalState createState() => _UserListModalState();
}

class _UserListModalState extends State<UserListModal> {
  List<User> filteredList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredList = widget.users;
  }

  void filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredList = widget.users
          .where((user) =>
              user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Выбери собеседника'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: 'Поиск',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                final user = filteredList[index];

                return ListTile(
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  leading: Text('${user.id}'),
                  onTap: () {
                    widget.onUserSelected(user);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
