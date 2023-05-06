import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
  dynamic dataUser = '';
  bool isLoading = true;

  void getUser() async {
    // debugPrint('До получения $isLoading');

    GetToken().getAccessToken().then((value) {
      String? result = value;
      if (result != null) {
        final jwtToken = Jwt.parseJwt(result);
        List<dynamic> roles = jwtToken['role'];
        List<String> authorities = [];
        for (var role in roles) {
          authorities.add(role['authority']);
        }

        // Получение User

        if (authorities.contains('ROLE_STUDENT')) {
          // debugPrint('Это Студент');
          GetUser().getStudent().then((data) {
            Map<String, dynamic> result = jsonDecode(data);
            setState(() {
              isLoading = false;
              dataUser = result;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          // debugPrint('Это преподаватель');
          GetUser().getTeacher().then((data) {
            Map<String, dynamic> result = jsonDecode(data);
            setState(() {
              isLoading = false;
              dataUser = result;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dataUser == '') {
      getUser();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: Column(children: [
        SizedBox(
          height: 200,
          width: 200,
        ),
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
}
