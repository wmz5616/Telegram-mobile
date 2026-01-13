import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';

class AuthState {
  final User currentUser;
  final List<User> availableAccounts;

  AuthState({required this.currentUser, required this.availableAccounts});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(_initialState());

  static AuthState _initialState() {
    final user1 = User(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1 234 567 890',
      avatarColor: Colors.blueAccent,
    );

    final user2 = User(
      id: '2',
      firstName: 'Alice',
      lastName: 'Wonder',
      phoneNumber: '+44 7911 123456',
      avatarColor: Colors.purple,
    );

    return AuthState(
      currentUser: user1,
      availableAccounts: [user1, user2],
    );
  }

  void switchAccount(User user) {
    if (state.currentUser.id != user.id) {
      state = AuthState(
        currentUser: user,
        availableAccounts: state.availableAccounts,
      );
    }
  }

  void addAccount() {
    final newAccount = User(
      id: DateTime.now().toString(),
      firstName: 'New',
      lastName: 'User',
      phoneNumber: '+86 138 0000 0000',
      avatarColor: Colors.orange,
    );

    state = AuthState(
      currentUser: newAccount,
      availableAccounts: [...state.availableAccounts, newAccount],
    );
  }

  void updateUser(User updatedUser) {
    final updatedCurrentUser = updatedUser;

    final updatedAccounts = state.availableAccounts.map((user) {
      return user.id == updatedUser.id ? updatedUser : user;
    }).toList();

    state = AuthState(
      currentUser: updatedCurrentUser,
      availableAccounts: updatedAccounts,
    );
  }

  void logout() {
    debugPrint("User logged out");
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
