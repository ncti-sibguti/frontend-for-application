import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

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
    // TODO: implement initState
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
              'Create Group Chat',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            MultiSelectDialogField(
                items: users
                    .map((user) => MultiSelectItem<User>(
                          user,
                          user.lastName,
                        ))
                    .toList(),
                title: Text('Select Users'),
                buttonText: Text('Select'),
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
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
