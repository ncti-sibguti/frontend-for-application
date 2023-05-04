import 'package:flutter/material.dart';
import 'package:ncti/routes/router.dart';
import 'package:ncti/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(
          // navigatorObservers: () => {
          //   TalkerRouteObserver(GetIt.I<Talker>)
          // }
          ),
      debugShowCheckedModeBanner: false,
      title: 'NCTI App',
      theme: light,
      darkTheme: dark,
    );
  }
}
