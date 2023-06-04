import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import 'package:ncti/routes/router.dart';
import 'package:ncti/theme_changer.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final themeModel = ThemeModel();
  await themeModel.loadTheme();
  initializeDateFormatting().then((_) => runApp(ChangeNotifierProvider.value(
        value: themeModel,
        child: const MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      // Handle the notification received while the app is in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: $message');
      // Handle the notification opened by the user while the app was in the background
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('onBackgroundMessage: $message');
    // Handle the notification received while the app is in the background
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return Consumer<ThemeModel>(
      builder: (context, model, child) {
        return MaterialApp.router(
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          title: 'NCTI App',
          theme: model.currentTheme,
          // themeMode: ThemeMode.system,
        );
      },
    );
  }
}
