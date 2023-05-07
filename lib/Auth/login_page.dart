import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

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
              const SizedBox(
                height: 50,
              ),
              // SizedBox(
              //   height: 170,
              //   child: Image.asset('assets/logo.png'),
              // ),
              SizedBox(height: 170, child: SvgPicture.asset('assets/logo.svg')),
              const SizedBox(height: 50),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите логин';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // цвет текста
                  backgroundColor:
                      Theme.of(context).primaryColor, // цвет кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // скругление углов
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15), // отступы внутри кнопки
                ),
                onPressed: () async {
                  if (await LoginRepositories()
                      .login(_usernameController, _passwordController)) {
                    if (context.mounted) {
                      AutoRouter.of(context).pushAndPopUntil(const HomeRoute(),
                          predicate: (route) => route.settings.name == '/home');
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
                child: const Text(
                  'Логин',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              // TextButton(
              //     onPressed: () async {
              //       final prefs = await SharedPreferences.getInstance();
              //       await prefs.setString('refreshToken',
              //           'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhMTY5ODI3MyIsImlzcyI6Im5jdGktYmFja2VuZCIsImV4cCI6MTY4NDMwMTI4MCwiaWF0IjoxNjgzMDkxNjgwfQ.ZXmYOclheUXlA9Q916PJDNcm2_0dLSn3Dyp2eyJ3UB5kBioQyFDywlVOEMItCm5_FNC7WZ4XRbKl1As7_xBHmA');
              //     },
              //     child: Text('SetToken')),
              // TextButton(
              //   onPressed: () {
              //     AutoRouter.of(context).pushAndPopUntil(HomeRoute(),
              //         predicate: (route) => route.settings.name == '/home');
              //   },
              //   child:
              //       Text(style: Theme.of(context).textTheme.bodyMedium, 'Home'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
