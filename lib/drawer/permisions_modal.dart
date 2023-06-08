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
            //TODO стилизуй кнопки
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
