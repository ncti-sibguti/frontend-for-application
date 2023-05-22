import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/schedule_page.dart';
import 'package:ncti/maps/user_page.dart';
import 'package:ncti/calendar/calendar.dart';
import 'package:ncti/chat/chats_page.dart';
import 'package:ncti/chat/public_chat_page.dart';
import 'package:ncti/chat/private_chat_page.dart';
import 'package:ncti/Auth/change_password.dart';

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
        AutoRoute(path: '/', page: HomeRoute.page, initial: true, children: [
          AutoRoute(page: ScheduleRoute.page, initial: true),
          AutoRoute(page: UserRoute.page),
          AutoRoute(page: ChatRoute.page),
        ]),
        AutoRoute(page: PublicChatRoute.page),
        AutoRoute(page: PersonalyChatRoute.page),
        //drawer
        AutoRoute(page: CalendarRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: LoginRoute.page),
      ];
}
