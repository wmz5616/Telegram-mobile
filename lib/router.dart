import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/chat/presentation/chat_list_screen.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/chat/presentation/chat_info_screen.dart';
import 'features/chat/data/models/chat.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/presentation/settings_sub_screens.dart';
import 'features/chat/presentation/widgets/side_menu_placeholders.dart';
// ignore: unused_import
import 'features/auth/data/models/user.dart';
// ignore: unused_import
import 'features/contacts/presentation/contacts_screen.dart' hide ContactsScreen;

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          if (state.extra is Chat) {
            return ChatScreen(chat: state.extra as Chat);
          } else {
            final chatId = int.parse(state.pathParameters['id']!);
            return ChatScreen(
                chat: Chat(
              id: chatId,
              title: "Unknown Chat",
              lastMessage: "",
              lastTime: DateTime.now(),
              unreadCount: 0,
              avatarColor: const Color(0xFFCCCCCC),
            ));
          }
        },
      ),
      GoRoute(
        path: '/chat_info',
        builder: (context, state) {
          final chat = state.extra as Chat;
          return ChatInfoScreen(chat: chat);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
              path: 'notifications',
              builder: (context, state) => const NotificationsSettingsScreen()),
          GoRoute(
              path: 'privacy',
              builder: (context, state) => const PrivacySettingsScreen()),
          GoRoute(
              path: 'data',
              builder: (context, state) => const DataSettingsScreen()),
          GoRoute(
              path: 'chat_settings',
              builder: (context, state) => const ChatSettingsScreen()),
          GoRoute(
              path: 'devices',
              builder: (context, state) => const DevicesSettingsScreen()),
          GoRoute(
              path: 'language',
              builder: (context, state) => const LanguageSettingsScreen()),
        ],
      ),
      GoRoute(
          path: '/new_group',
          builder: (context, state) => const NewGroupScreen()),
      GoRoute(
          path: '/contacts',
          builder: (context, state) => const ContactsScreen()),
      GoRoute(path: '/calls', builder: (context, state) => const CallsScreen()),
      GoRoute(
          path: '/nearby',
          builder: (context, state) => const PeopleNearbyScreen()),
    ],
  );
});
