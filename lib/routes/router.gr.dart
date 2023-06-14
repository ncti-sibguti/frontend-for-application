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
    PrivateChatRoute.name: (routeData) {
      final args = routeData.argsAs<PrivateChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PrivateChatPage(
          key: args.key,
          group: args.group,
          chatId: args.chatId,
        ),
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
      final args = routeData.argsAs<UserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    GroupLessonsRoute.name: (routeData) {
      final args = routeData.argsAs<GroupLessonsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GroupLessonsPage(group: args.group),
      );
    },
    LessonDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<LessonDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LessonDetailsPage(
          lesson: args.lesson,
          day: args.day,
          isTeacher: args.isTeacher,
        ),
      );
    },
    ScheduleRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SchedulePage(),
      );
    },
    ButtonRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ButtonPage(),
      );
    },
    UserListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserListPage(),
      );
    },
    CreatePrivateChatRoute.name: (routeData) {
      final args = routeData.argsAs<CreatePrivateChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreatePrivateChatPage(
          key: args.key,
          group: args.group,
          chatId: args.chatId,
          email: args.email,
        ),
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
/// [PrivateChatPage]
class PrivateChatRoute extends PageRouteInfo<PrivateChatRouteArgs> {
  PrivateChatRoute({
    Key? key,
    required Group group,
    required String chatId,
    List<PageRouteInfo>? children,
  }) : super(
          PrivateChatRoute.name,
          args: PrivateChatRouteArgs(
            key: key,
            group: group,
            chatId: chatId,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'PrivateChatRoute';

  static const PageInfo<PrivateChatRouteArgs> page =
      PageInfo<PrivateChatRouteArgs>(name);
}

class PrivateChatRouteArgs {
  const PrivateChatRouteArgs({
    this.key,
    required this.group,
    required this.chatId,
  });

  final Key? key;

  final Group group;

  final String chatId;

  @override
  String toString() {
    return 'PrivateChatRouteArgs{key: $key, group: $group, chatId: $chatId}';
  }
}

/// generated route for
/// [PublicChatPage]
class PublicChatRoute extends PageRouteInfo<PublicChatRouteArgs> {
  PublicChatRoute({
    Key? key,
    required String chatId,
    required Group group,
    List<PageRouteInfo>? children,
  }) : super(
          PublicChatRoute.name,
          args: PublicChatRouteArgs(
            key: key,
            chatId: chatId,
            group: group,
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
  });

  final Key? key;

  final String chatId;

  final Group group;

  @override
  String toString() {
    return 'PublicChatRouteArgs{key: $key, chatId: $chatId, group: $group}';
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
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const PageInfo<UserRouteArgs> page = PageInfo<UserRouteArgs>(name);
}

class UserRouteArgs {
  const UserRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'UserRouteArgs{key: $key, id: $id}';
  }
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
/// [LessonDetailsPage]
class LessonDetailsRoute extends PageRouteInfo<LessonDetailsRouteArgs> {
  LessonDetailsRoute({
    required dynamic lesson,
    required DateTime day,
    required bool isTeacher,
    List<PageRouteInfo>? children,
  }) : super(
          LessonDetailsRoute.name,
          args: LessonDetailsRouteArgs(
            lesson: lesson,
            day: day,
            isTeacher: isTeacher,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonDetailsRoute';

  static const PageInfo<LessonDetailsRouteArgs> page =
      PageInfo<LessonDetailsRouteArgs>(name);
}

class LessonDetailsRouteArgs {
  const LessonDetailsRouteArgs({
    required this.lesson,
    required this.day,
    required this.isTeacher,
  });

  final dynamic lesson;

  final DateTime day;

  final bool isTeacher;

  @override
  String toString() {
    return 'LessonDetailsRouteArgs{lesson: $lesson, day: $day, isTeacher: $isTeacher}';
  }
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
/// [UserListPage]
class UserListRoute extends PageRouteInfo<void> {
  const UserListRoute({List<PageRouteInfo>? children})
      : super(
          UserListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreatePrivateChatPage]
class CreatePrivateChatRoute extends PageRouteInfo<CreatePrivateChatRouteArgs> {
  CreatePrivateChatRoute({
    Key? key,
    required Group group,
    required String chatId,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          CreatePrivateChatRoute.name,
          args: CreatePrivateChatRouteArgs(
            key: key,
            group: group,
            chatId: chatId,
            email: email,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'CreatePrivateChatRoute';

  static const PageInfo<CreatePrivateChatRouteArgs> page =
      PageInfo<CreatePrivateChatRouteArgs>(name);
}

class CreatePrivateChatRouteArgs {
  const CreatePrivateChatRouteArgs({
    this.key,
    required this.group,
    required this.chatId,
    required this.email,
  });

  final Key? key;

  final Group group;

  final String chatId;

  final String email;

  @override
  String toString() {
    return 'CreatePrivateChatRouteArgs{key: $key, group: $group, chatId: $chatId, email: $email}';
  }
}
