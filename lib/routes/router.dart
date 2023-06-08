import 'package:flutter/material.dart';
import '/repository/ncti_repository.dart';
import '/schedule/schedule_page.dart';
import '/maps/user_page.dart';
import '/drawer/calendar/calendar.dart';
import '/chat/chats_page.dart';
import '/chat/public_chat_page.dart';

import '/drawer/change_password.dart';
import '/drawer/time_schedule.dart';

import '/Auth/login_page.dart';
import '/schedule/widgets/button_page.dart';
import '/schedule/group_lesson.dart';

import '/home_screen.dart';
import 'package:auto_route/auto_route.dart';

import '/schedule/lesson_details.dart';

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
//schedule
        AutoRoute(page: LessonDetailsRoute.page),

        AutoRoute(page: ButtonRoute.page),
        AutoRoute(page: GroupLessonsRoute.page),

        //chat
        AutoRoute(page: PublicChatRoute.page),

        //drawer
        AutoRoute(page: CalendarRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: TimeScheduleRoute.page)
      ];
}
