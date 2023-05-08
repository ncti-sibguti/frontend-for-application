import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  void removeToken() {
    GetToken().removeToken();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      onPressed: () {
        if (Theme.of(context).brightness == Brightness.dark) {
          return debugPrint('темная');
        } else {
          return debugPrint('светлая');
        }
      },
      child: const Text('gjfjg'),
    ));
  }
}
