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
    return const Center(
      child: Text('В разработке'),
    );
  }
}
