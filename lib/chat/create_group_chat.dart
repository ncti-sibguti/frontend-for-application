import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateGroupChatModal extends StatefulWidget {
  @override
  _CreateGroupChatModalState createState() => _CreateGroupChatModalState();
}

class _CreateGroupChatModalState extends State<CreateGroupChatModal> {
  TextEditingController _groupNameController = TextEditingController();
  List<User> users = [];
  List<User> _selectedUsers = [];
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();
    gettingUser();
  }

  void gettingUser() {
    GetUser().getAllUser().then((data) {
      setState(() {
        users = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Создать групповой чат',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                  labelText: 'Название группы',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            const SizedBox(height: 16.0),
            MultiSelectDialogField(
                confirmText: Text(
                  'Подтвердить',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
                cancelText: Text(
                  'Отмена',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
                itemsTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.background),
                selectedItemsTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.background),
                selectedColor: Theme.of(context).colorScheme.secondary,
                items: users
                    .map((user) => MultiSelectItem<User>(
                          user,
                          '${user.firstName} ${user.lastName}',
                        ))
                    .toList(),
                title: const Text('Выберите пользователей'),
                buttonText: const Text('Выбрать пользователей'),
                onConfirm: (selectedUsers) {
                  setState(() {
                    _selectedUsers = selectedUsers;
                  });
                }),
            ElevatedButton(
              onPressed: () {
                String groupName = _groupNameController.text;
                List<int> selectedIds =
                    _selectedUsers.map((user) => user.id).toList();
                GetChat().createChat(groupName, selectedIds);

                Navigator.pop(context);
              },
              child: Text(
                'Создать чат',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
