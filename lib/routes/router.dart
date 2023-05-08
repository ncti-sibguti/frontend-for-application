import 'package:ncti/chat/chat_page.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/schedule_page.dart';
import 'package:ncti/profile/user_page.dart';

import 'package:ncti/Auth/login_page.dart';

import 'package:ncti/home_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await AuthorizationRepositories().isLogin() ||
        resolver.route.name == LoginRoute.name) {
      // debugPrint('AuthGuard True');
      // we continue navigation
      resolver.next();
    } else {
      // debugPrint('AuthGuard False');
      // else we navigate to the Login page so we get authenticateed
      push(const LoginRoute());
    }
  }

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true, children: [
          AutoRoute(page: ScheduleRoute.page, initial: true),
          AutoRoute(page: UserRoute.page),
          AutoRoute(page: ChatRoute.page),
        ]),
        // AutoRoute(page: ScheduleRoute.page),
        // AutoRoute(page: UserRoute.page),
        // AutoRoute(page: ChatRoute.page),
        AutoRoute(page: LoginRoute.page),
      ];
}
