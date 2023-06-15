import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ncti/notifications/notification_service.dart';
import '/repository/ncti_repository.dart';
import '/routes/router.dart';
import '/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? id;
  bool isLoading = true;

  void getId() async {
    GetToken().getAccessToken().then((value) {
      if (value != null) {
        final jwtToken = Jwt.parseJwt(value);

        id = jwtToken['user_id'];

        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getId();
    UpdateToken().updateToken();
    NotificationServices().requestNotificationPermission();
    NotificationServices().forgroundMessage();
    NotificationServices().firebaseInit(context);
    NotificationServices().setupInteractMessage(context);
    NotificationServices().isTokenRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return AutoTabsScaffold(
        routes: [ScheduleRoute(), ChatRoute(), UserRoute(id: id!)],
        appBarBuilder: (_, tabsRouter) => AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('КТИ СибГУТИ'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  themeProvider.toggleTheme();
                },
                child: Icon(Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.nights_stay_outlined),
              ),
            ),
          ],
        ),
        bottomNavigationBuilder: (_, tabsRouter) => SalomonBottomBar(
            selectedItemColor: Theme.of(context).colorScheme.background,
            unselectedItemColor: Theme.of(context).colorScheme.background,
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
                  icon: const Icon(Icons.person_3_outlined),
                  title: const Text('Профиль'))
            ]),
      );
    }
  }
}
