import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:ncti/drawer/permisions_modal.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/chat/chat_repository.dart';
import 'package:ncti/maps/model/student.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';

@RoutePage()
class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.id});

  final int id;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User? dataUser;
  bool isLoading = true;
  bool isTeacher = false;
  bool isI = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    int? id;
    GetToken().getAccessToken().then((value) {
      String? result = value;
      if (result != null) {
        final jwtToken = Jwt.parseJwt(result);

        id = jwtToken['user_id'];
      }
      if (widget.id == id) {
        setState(() {
          isI = true;
        });
      }
    });
    GetUser().getUser(widget.id.toString()).then((value) {
      User respon = User.fromJson(jsonDecode(value));
      setState(() {
        dataUser = respon;
        isLoading = false;
      });
    });
  }

  final List<String> items = [
    'Календарь',
    'Расписание звонков',
    'Пользователи',
    'Включить уведомления',
    'Сменить пароль',
    'Выйти'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dataUser!.lastname,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              dataUser!.firstname,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                            const SizedBox(height: 8.0),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: dataUser!.role.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final role = dataUser!.role[index];
                                  return Center(
                                    child: Text(
                                      role['description'],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  isI
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Theme.of(context).cardColor,
                                child: ListTile(
                                  title: Text(
                                    items[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        AutoRouter.of(context)
                                            .push(const CalendarRoute());
                                        break;
                                      case 1:
                                        AutoRouter.of(context)
                                            .push(const TimeScheduleRoute());
                                        break;
                                      case 2:
                                        AutoRouter.of(context)
                                            .push(const UserListRoute());
                                        break;
                                      case 3:
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return PermissionsModal();
                                          },
                                        );
                                        break;
                                      case 4:
                                        AutoRouter.of(context)
                                            .push(ChangePasswordRoute());
                                        break;

                                      case 5:
                                        NotificationRep().deleteToken();
                                        GetToken().removeToken();

                                        AutoRouter.of(context).pushAndPopUntil(
                                            const LoginRoute(),
                                            predicate: (route) =>
                                                route.settings.name ==
                                                '/login');
                                        break;
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Card(
                          child: ListTile(
                          title: Text(
                            'Написать сообщение',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          onTap: () {
                            if (dataUser!.chat != null) {
                              AutoRouter.of(context).push(PrivateChatRoute(
                                  group: Group(
                                      id: dataUser!.chat!,
                                      name:
                                          '${dataUser!.firstname} ${dataUser!.lastname}',
                                      type: 'PRIVATE'),
                                  chatId: dataUser!.chat!));
                            } else {
                              String _id = Uuid().v4();
                              AutoRouter.of(context).push(CreatePrivateChatRoute(
                                  group: Group(
                                      id: _id,
                                      name:
                                          '${dataUser!.firstname} ${dataUser!.lastname}',
                                      type: 'PRIVATE'),
                                  chatId: _id,
                                  email: dataUser!.email));
                            }
                          },
                        ))
                ],
              ),
            ),
    );
  }
}
