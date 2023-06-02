// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    ChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatPage(),
      );
    },
    PublicChatRoute.name: (routeData) {
      final args = routeData.argsAs<PublicChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PublicChatPage(
          key: args.key,
          chatId: args.chatId,
          group: args.group,
          accessToken: args.accessToken,
          id: args.id,
        ),
      );
    },
    CalendarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarPage(),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChangePasswordPage(),
      );
    },
    TimeScheduleRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimeSchedulePage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    UserRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserPage(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SchedulePage(),
      );
    },
    StudentLessonDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<StudentLessonDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StudentLessonDetailsPage(lesson: args.lesson),
      );
    },
    ButtonRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ButtonPage(),
      );
    },
    GroupLessonsRoute.name: (routeData) {
      final args = routeData.argsAs<GroupLessonsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GroupLessonsPage(group: args.group),
      );
    },
    TeacherLessonDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TeacherLessonDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TeacherLessonDetailsPage(lesson: args.lesson),
      );
    },
  };
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
      : super(
          ChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PublicChatPage]
class PublicChatRoute extends PageRouteInfo<PublicChatRouteArgs> {
  PublicChatRoute({
    Key? key,
    required String chatId,
    required Group group,
    required String accessToken,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PublicChatRoute.name,
          args: PublicChatRouteArgs(
            key: key,
            chatId: chatId,
            group: group,
            accessToken: accessToken,
            id: id,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'PublicChatRoute';

  static const PageInfo<PublicChatRouteArgs> page =
      PageInfo<PublicChatRouteArgs>(name);
}

class PublicChatRouteArgs {
  const PublicChatRouteArgs({
    this.key,
    required this.chatId,
    required this.group,
    required this.accessToken,
    required this.id,
  });

  final Key? key;

  final String chatId;

  final Group group;

  final String accessToken;

  final String id;

  @override
  String toString() {
    return 'PublicChatRouteArgs{key: $key, chatId: $chatId, group: $group, accessToken: $accessToken, id: $id}';
  }
}

/// generated route for
/// [CalendarPage]
class CalendarRoute extends PageRouteInfo<void> {
  const CalendarRoute({List<PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChangePasswordPage]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimeSchedulePage]
class TimeScheduleRoute extends PageRouteInfo<void> {
  const TimeScheduleRoute({List<PageRouteInfo>? children})
      : super(
          TimeScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'TimeScheduleRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<void> {
  const UserRoute({List<PageRouteInfo>? children})
      : super(
          UserRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SchedulePage]
class ScheduleRoute extends PageRouteInfo<void> {
  const ScheduleRoute({List<PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StudentLessonDetailsPage]
class StudentLessonDetailsRoute
    extends PageRouteInfo<StudentLessonDetailsRouteArgs> {
  StudentLessonDetailsRoute({
    required StudentLesson lesson,
    List<PageRouteInfo>? children,
  }) : super(
          StudentLessonDetailsRoute.name,
          args: StudentLessonDetailsRouteArgs(lesson: lesson),
          initialChildren: children,
        );

  static const String name = 'StudentLessonDetailsRoute';

  static const PageInfo<StudentLessonDetailsRouteArgs> page =
      PageInfo<StudentLessonDetailsRouteArgs>(name);
}

class StudentLessonDetailsRouteArgs {
  const StudentLessonDetailsRouteArgs({required this.lesson});

  final StudentLesson lesson;

  @override
  String toString() {
    return 'StudentLessonDetailsRouteArgs{lesson: $lesson}';
  }
}

/// generated route for
/// [ButtonPage]
class ButtonRoute extends PageRouteInfo<void> {
  const ButtonRoute({List<PageRouteInfo>? children})
      : super(
          ButtonRoute.name,
          initialChildren: children,
        );

  static const String name = 'ButtonRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GroupLessonsPage]
class GroupLessonsRoute extends PageRouteInfo<GroupLessonsRouteArgs> {
  GroupLessonsRoute({
    required ScheduleGroup group,
    List<PageRouteInfo>? children,
  }) : super(
          GroupLessonsRoute.name,
          args: GroupLessonsRouteArgs(group: group),
          initialChildren: children,
        );

  static const String name = 'GroupLessonsRoute';

  static const PageInfo<GroupLessonsRouteArgs> page =
      PageInfo<GroupLessonsRouteArgs>(name);
}

class GroupLessonsRouteArgs {
  const GroupLessonsRouteArgs({required this.group});

  final ScheduleGroup group;

  @override
  String toString() {
    return 'GroupLessonsRouteArgs{group: $group}';
  }
}

/// generated route for
/// [TeacherLessonDetailsPage]
class TeacherLessonDetailsRoute
    extends PageRouteInfo<TeacherLessonDetailsRouteArgs> {
  TeacherLessonDetailsRoute({
    required TeacherLesson lesson,
    List<PageRouteInfo>? children,
  }) : super(
          TeacherLessonDetailsRoute.name,
          args: TeacherLessonDetailsRouteArgs(lesson: lesson),
          initialChildren: children,
        );

  static const String name = 'TeacherLessonDetailsRoute';

  static const PageInfo<TeacherLessonDetailsRouteArgs> page =
      PageInfo<TeacherLessonDetailsRouteArgs>(name);
}

class TeacherLessonDetailsRouteArgs {
  const TeacherLessonDetailsRouteArgs({required this.lesson});

  final TeacherLesson lesson;

  @override
  String toString() {
    return 'TeacherLessonDetailsRouteArgs{lesson: $lesson}';
  }
}
