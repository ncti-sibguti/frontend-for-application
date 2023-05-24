// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена пароля'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 150.0),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.background),
              controller: _newPasswordController,
              decoration: InputDecoration(
                  labelText: 'Новый пароль',
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  errorText: _isPasswordValid
                      ? null
                      : 'Минимальная длина пароля: 6 символов'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.background),
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  labelText: 'Подтвердите новый пароль',
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                  errorText: _isPasswordValid
                      ? null
                      : 'Минимальная длина пароля: 6 символов'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // цвет текста
                backgroundColor: Theme.of(context).primaryColor, // цвет кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // скругление углов
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15), // отступы внутри кнопки
              ),
              onPressed: () {
                String newPassword = _newPasswordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (newPassword.length >= 6 && newPassword == confirmPassword) {
                  LoginRepositories()
                      .changePassword(_confirmPasswordController);
                  // Выполнение смены пароля
                  // TODO: Добавьте код для выполнения смены пароля
                } else {
                  setState(() {
                    _isPasswordValid = false;
                  });
                  // Обработка ошибки неподходящего подтверждения пароля
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Ошибка'),
                        content:
                            const Text('Подтверждение пароля не совпадает.'),
                        actions: [
                          ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Сменить пароль'),
            ),
          ],
        ),
      ),
    );
  }
}
