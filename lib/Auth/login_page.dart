import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:ncti/repository/ncti_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ncti/routes/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Авторизация'),
          backgroundColor: Theme.of(context).primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 150),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  if (await LoginRepositories()
                      .login(_usernameController, _passwordController)) {
                    if (context.mounted) {
                      AutoRouter.of(context).push(
                        const HomeRoute(),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      return showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Неверный логин или пароль'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      AutoRouter.of(context).pop();
                                    },
                                    child: const Text('Понял'))
                              ],
                            );
                          });
                    }
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('refreshToken',
                        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhMTY5ODI3MyIsImlzcyI6Im5jdGktYmFja2VuZCIsImV4cCI6MTY4NDMwMTI4MCwiaWF0IjoxNjgzMDkxNjgwfQ.ZXmYOclheUXlA9Q916PJDNcm2_0dLSn3Dyp2eyJ3UB5kBioQyFDywlVOEMItCm5_FNC7WZ4XRbKl1As7_xBHmA');
                  },
                  child: Text('SetToken')),
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pushAndPopUntil(HomeRoute(),
                      predicate: (route) => route.settings.name == '/home');
                },
                child:
                    Text(style: Theme.of(context).textTheme.bodyMedium, 'Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
