import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/maps/model/student.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

@RoutePage()
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];
  bool isLoading = true;
  String searchQuery = '';
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    gettingUser();
  }

  // List<User> _filteredUsers = [];

  void gettingUser() {
    GetUser().getAllUser().then((data) {
      setState(() {
        users = data;
        isLoading = false;
        filteredUsers = data;
        // _filteredUsers = data;
      });
    });
  }

  void filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = users.where((user) {
        final fullName = '${user.firstname} ${user.lastname}';
        return fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Пользователи',
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Пользователи'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                onChanged: filterUsers,
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                    labelText: 'Поиск',
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Theme.of(context).colorScheme.background),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    onTap: () {
                      AutoRouter.of(context).push(UserRoute(id: user.id));
                    },
                    title: Text(
                      '${user.firstname} ${user.lastname}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    subtitle: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: user.role.length,
                        itemBuilder: (BuildContext context, int index) {
                          final role = user.role[index];
                          return Text(
                            role['description'],
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
