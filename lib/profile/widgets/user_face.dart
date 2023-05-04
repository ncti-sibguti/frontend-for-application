import 'package:flutter/material.dart';

@override
Widget userFace(
    BuildContext context, String lastName, firstName, surname, email) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20),
    width: 400,
    height: 240,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              'https://picsum.photos/seed/198/600',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Text('Not Found'),
            ),
          ],
        ),
        Align(
            child: Container(
          margin: EdgeInsets.only(left: 40),
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(lastName),
                Text(firstName),
                Text(surname),
                Text(email),
              ],
            ),
          ),
        )),
      ],
    ),
  );
}
