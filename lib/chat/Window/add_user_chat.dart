import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:ncti/chat/chat_repository.dart';
import 'package:ncti/maps/model/student.dart';

import '../../repository/ncti_repository.dart';

class AddUserChat extends StatefulWidget {
  const AddUserChat({super.key, required this.chatId});
  final String chatId;
  @override
  State<AddUserChat> createState() => _AddUserChatState();
}

class _AddUserChatState extends State<AddUserChat> {
  List<User> users = [];
  List<User> _filteredUsers = [];
  List<User> _selectedUsers = [];
  List<int> selectedIds = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    gettingUser();
  }

  void gettingUser() {
    GetUser().getAllUser().then((data) {
      setState(() {
        users = data;
        _filteredUsers = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                MultiSelectDialogField(
                  searchable: true,
                  searchHint: 'Поиск',
                  searchTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
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
                  itemsTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  selectedItemsTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  items: _filteredUsers
                      .map((user) => MultiSelectItem<User>(
                            user,
                            '${user.firstname} ${user.lastname}',
                          ))
                      .toList(),
                  title: Text(
                    'Пользователи',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  buttonText: const Text('Выбрать пользователей'),
                  onConfirm: (selectedUsers) {
                    setState(() {
                      _selectedUsers = selectedUsers;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // скругление углов
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15), // отступы внутри кнопки
                  ),
                  onPressed: () {
                    List<int> selectedIds =
                        _selectedUsers.map((user) => user.id).toList();

                    if (_formKey.currentState!.validate()) {
                      GetChat().addUserToChat(widget.chatId, selectedIds);

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Добавляем пользователя в чатик')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          )),
    );
  }
}
