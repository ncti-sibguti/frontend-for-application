import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';
import 'package:ncti/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    UpdateToken().updateToken();
  }

  dynamic dataUser = '';
  bool isLoading = true;

  void getUser() async {
    // debugPrint('До получения $isLoading');

    GetToken().getAccessToken().then((value) {
      String? result = value;
      if (result != null) {
        final jwtToken = Jwt.parseJwt(result);
        List<dynamic> roles = jwtToken['role'];
        List<String> authorities = [];
        for (var role in roles) {
          authorities.add(role['authority']);
        }

        // Получение User

        if (authorities.contains('ROLE_STUDENT')) {
          // debugPrint('Студент юзер запрос');
          // debugPrint('Это Студент');
          GetUser().getStudent().then((data) {
            Map<String, dynamic> result = jsonDecode(data);
            setState(() {
              isLoading = false;
              dataUser = result;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        } else if (authorities.contains('ROLE_TEACHER')) {
          // debugPrint('Тичер юзер запрос');
          // debugPrint('Это преподаватель');
          GetUser().getTeacher().then((data) {
            Map<String, dynamic> result = jsonDecode(data);
            setState(() {
              isLoading = false;
              dataUser = result;
            });
            // debugPrint('После получения $isLoading');
            // AutoRouter.of(context).pop();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);

    if (isLoading) {
      getUser();
      return AutoTabsScaffold(
        routes: const [ScheduleRoute(), ChatRoute(), UserRoute()],
        appBarBuilder: (_, tabsRouter) => AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('КТИ СибГУТИ'),
        ),
        bottomNavigationBuilder: (_, tabsRouter) => SalomonBottomBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              SalomonBottomBarItem(
                  icon: const Icon(Icons.schedule_outlined),
                  title: const Text('Расписание')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.message_outlined),
                  title: const Text('Чат')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.map_outlined),
                  title: const Text('Карта'))
            ]),
      );
    } else {
      return AutoTabsScaffold(
        routes: const [ScheduleRoute(), ChatRoute(), UserRoute()],
        appBarBuilder: (_, tabsRouter) => AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('КТИ СибГУТИ'),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person_outline_outlined),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${dataUser['lastname']} ${dataUser['firstname']}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text('${dataUser['email']}',
                        style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.nights_stay_outlined),
                title: Text('Сменить тему',
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  themeProvider.toggleTheme();
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month_outlined),
                title: Text('Календарь',
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  AutoRouter.of(context).push(CalendarRoute());
                },
              ),
              ListTile(
                leading: const Icon(Icons.door_sliding_outlined),
                title: Text('Выйти',
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  GetToken().removeToken();
                  AutoRouter.of(context).pushAndPopUntil(const LoginRoute(),
                      predicate: (route) => route.settings.name == '/login');
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        bottomNavigationBuilder: (_, tabsRouter) => SalomonBottomBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              SalomonBottomBarItem(
                  icon: const Icon(Icons.schedule_outlined),
                  title: const Text('Расписание')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.message_outlined),
                  title: const Text('Чат')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.map_outlined),
                  title: const Text('Карта'))
            ]),
      );
    }
  }
}
