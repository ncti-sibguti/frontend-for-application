import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/routes/router.dart';
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

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [ScheduleRoute(), ChatRoute(), UserRoute()],
      appBarBuilder: (_, tabsRouter) => AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('КТИ СибГУТИ'),
      ),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(65, 45, 166, 1)),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.door_back_door_outlined),
              title: const Text('Выйти'),
              onTap: () {
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
                icon: const Icon(Icons.person_outline),
                title: const Text('Личный кабинет'))
          ]),
    );
  }
}
