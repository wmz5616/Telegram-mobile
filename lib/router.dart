import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/chat/presentation/chat_list_screen.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const ChatListScreen(),
        routes: [
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return ChatScreen(userName: args['name']);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page not found')),
    ),
  );
});
