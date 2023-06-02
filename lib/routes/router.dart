import 'package:flutter/material.dart';
import 'package:ncti/repository/ncti_repository.dart';
import 'package:ncti/schedule/schedule_page.dart';
import 'package:ncti/maps/user_page.dart';
import 'package:ncti/drawer/calendar/calendar.dart';
import 'package:ncti/chat/chats_page.dart';
import 'package:ncti/chat/public_chat_page.dart';

import 'package:ncti/drawer/change_password.dart';
import 'package:ncti/drawer/time_schedule.dart';

import 'package:ncti/Auth/login_page.dart';
import 'package:ncti/schedule/widgets/button_page.dart';
import 'package:ncti/schedule/group_lesson.dart';

import 'package:ncti/home_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ncti/schedule/student_lesson_details.dart';
import 'package:ncti/schedule/teacher_lesson_details.dart';

import '../schedule/models/student_schedule.dart';
import '../schedule/models/teacher_schedule.dart';

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
        AutoRoute(page: StudentLessonDetailsRoute.page),
        AutoRoute(page: TeacherLessonDetailsRoute.page),
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
