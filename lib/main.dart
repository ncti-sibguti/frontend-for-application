import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import 'package:ncti/routes/router.dart';
import 'package:ncti/theme_changer.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeModel = ThemeModel();
  await themeModel.loadTheme();
  initializeDateFormatting().then((_) => runApp(ChangeNotifierProvider.value(
        value: themeModel,
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  String get name => 'foo';
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    print('Initialized default app $app');
  }

  Future<void> delete() async {
    final FirebaseApp app = Firebase.app(name);
    await app.delete();
    print('App $name deleted');
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
