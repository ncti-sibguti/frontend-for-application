import 'package:flutter/material.dart';

import '../notifications/permissions.dart';

class PermissionsModal extends StatefulWidget {
  @override
  _PermissionsModalState createState() => _PermissionsModalState();
}

class _PermissionsModalState extends State<PermissionsModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Уведомления',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Permissions(),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context)
                        .colorScheme
                        .secondary), // Цвет фона кнопки
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context)
                        .colorScheme
                        .background), // Цвет текста кнопки
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 16), // Размер текста кнопки
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10), // Отступы кнопки
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Радиус закругления углов кнопки
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        ),
      ),
    );
  }
}
