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
    CalendarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarPage(),
      );
    },
    ChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatPage(),
      );
    },
    PersonalyChatRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalyChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PersonalyChatPage(
          key: args.key,
          chatId: args.chatId,
          user: args.user,
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
          accessToken: args.accessToken,
          id: args.id,
        ),
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
/// [PersonalyChatPage]
class PersonalyChatRoute extends PageRouteInfo<PersonalyChatRouteArgs> {
  PersonalyChatRoute({
    Key? key,
    required int chatId,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          PersonalyChatRoute.name,
          args: PersonalyChatRouteArgs(
            key: key,
            chatId: chatId,
            user: user,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'PersonalyChatRoute';

  static const PageInfo<PersonalyChatRouteArgs> page =
      PageInfo<PersonalyChatRouteArgs>(name);
}

class PersonalyChatRouteArgs {
  const PersonalyChatRouteArgs({
    this.key,
    required this.chatId,
    required this.user,
  });

  final Key? key;

  final int chatId;

  final User user;

  @override
  String toString() {
    return 'PersonalyChatRouteArgs{key: $key, chatId: $chatId, user: $user}';
  }
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
