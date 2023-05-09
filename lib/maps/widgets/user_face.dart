import 'package:flutter/material.dart';

@override
Widget userFace(
    BuildContext context, String lastName, firstName, surname, email) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: 400,
      height: 240,
      child: Column(children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage('assets/images/person_icon.png'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          height: 40,
        ),
        Text('$lastName $firstName $surname')
      ]));
}
