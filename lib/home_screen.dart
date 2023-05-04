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
                icon: const Icon(Icons.schedule),
                title: const Text('Расписание')),
            SalomonBottomBarItem(
                icon: const Icon(Icons.message), title: const Text('Чат')),
            SalomonBottomBarItem(
                icon: const Icon(Icons.person_2),
                title: const Text('Личный кабинет'))
          ]),
    );
  }
}
