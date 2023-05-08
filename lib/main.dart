import 'package:flutter/material.dart';
import 'package:ncti/routes/router.dart';
import 'package:ncti/theme_changer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeModel = ThemeModel();
  await themeModel.loadTheme();

  runApp(ChangeNotifierProvider.value(
    value: themeModel,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
