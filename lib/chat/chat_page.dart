import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/router.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          TextButton(
            onPressed: () {
              AutoRouter.of(context).push(const HomeRoute());
            },
            child: Text(style: Theme.of(context).textTheme.bodyMedium, 'Home'),
          ),
        ]),
      ),
    );
  }
}
