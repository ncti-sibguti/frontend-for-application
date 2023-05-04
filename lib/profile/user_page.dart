import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/profile/widgets/user_face.dart';

import '../repository/ncti_repository.dart';
import '../routes/router.dart';

@RoutePage()
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      userFace(context, 'person.lastName', 'person.firstName', 'person.surname',
          'person.email'),
      Card(
          child: SizedBox(
        height: 120,
        width: 120,
        child: TextButton(
          onPressed: () {
            GetToken().removeToken();
            AutoRouter.of(context).pushAndPopUntil(const LoginRoute(),
                predicate: (route) => route.settings.name == '/login');
          },
          child: Text(style: Theme.of(context).textTheme.bodyMedium, "Выйти"),
        ),
      ))
    ]));
  }
}
