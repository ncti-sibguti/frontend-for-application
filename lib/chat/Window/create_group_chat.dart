import 'package:flutter/material.dart';
import 'package:ncti/chat/chat_repository.dart';
import '/repository/ncti_repository.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateGroupChatModal extends StatefulWidget {
  final Function onChatCreated; // Колбэк для обновления списка чатов

  const CreateGroupChatModal({Key? key, required this.onChatCreated})
      : super(key: key);
  @override
  _CreateGroupChatModalState createState() => _CreateGroupChatModalState();
}

class _CreateGroupChatModalState extends State<CreateGroupChatModal> {
  TextEditingController _groupNameController = TextEditingController();
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
          padding: EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  return null;
                },
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Название группы',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // TextField(
              //   onChanged: _filterUsers,
              //   decoration: InputDecoration(
              //     labelText: 'Поиск пользователей',
              //     border: const OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 16.0),
              MultiSelectDialogField(
                searchable: true,
                searchHint: 'Поиск',
                searchTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.background),
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
                items: _filteredUsers
                    .map((user) => MultiSelectItem<User>(
                          user,
                          '${user.firstName} ${user.lastName}',
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // скругление углов
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15), // отступы внутри кнопки
                ),
                onPressed: () {
                  String groupName = _groupNameController.text;
                  List<int> selectedIds =
                      _selectedUsers.map((user) => user.id).toList();

                  if (_formKey.currentState!.validate()) {
                    GetChat().createChat(groupName, selectedIds);

                    widget.onChatCreated();
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Обновите страницу')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Создать чат'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
