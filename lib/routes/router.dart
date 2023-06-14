import 'package:flutter/material.dart';
import 'package:ncti/chat/Window/create_private_chat_page.dart';

import 'package:ncti/chat/chat_repository.dart';
import 'package:ncti/maps/list_user.dart';

import 'package:ncti/repository/ncti_repository.dart';

import 'package:ncti/maps/user_page.dart';

import 'package:ncti/chat/chats_page.dart';
import 'package:ncti/chat/public_chat_page.dart';
import 'package:ncti/chat/private_chat_page.dart';

import 'package:ncti/drawer/change_password.dart';
import 'package:ncti/drawer/calendar/calendar.dart';
import 'package:ncti/drawer/time_schedule.dart';

import 'package:ncti/auth/login_page.dart';

import 'package:ncti/home_screen.dart';
import 'package:auto_route/auto_route.dart';

import '/schedule/schedule_page.dart';
import '/schedule/group_lesson.dart';
import '/schedule/lesson_details.dart';
import '/schedule/widgets/button_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await AuthorizationRepositories().isLogin() ||
        resolver.route.name == LoginRoute.name) {
      //мы продолжаем навигацию
      resolver.next();
    } else {
      // в противном случае мы переходим на страницу входа, чтобы пройти аутентификацию.
      push(const LoginRoute());
    }
  }

  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: HomeRoute.page, initial: true, children: [
          AutoRoute(page: ScheduleRoute.page, initial: true),
          AutoRoute(page: UserRoute.page),
          AutoRoute(page: ChatRoute.page, path: 'chat'),
        ]),
//schedule
        AutoRoute(page: LessonDetailsRoute.page),

        AutoRoute(page: ButtonRoute.page),
        AutoRoute(page: GroupLessonsRoute.page),

        //chat
        AutoRoute(page: PublicChatRoute.page),
        AutoRoute(page: PrivateChatRoute.page),

        AutoRoute(page: CreatePrivateChatRoute.page),

        //drawer
        AutoRoute(page: CalendarRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: TimeScheduleRoute.page),
        AutoRoute(page: UserListRoute.page),
      ];
}
