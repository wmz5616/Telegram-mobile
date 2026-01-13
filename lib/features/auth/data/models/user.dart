import 'package:flutter/material.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Color avatarColor;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.avatarColor,
    this.avatarUrl,
  });

  String get fullName => "$firstName $lastName";

  String get initials =>
      firstName.isNotEmpty ? firstName[0].toUpperCase() : "?";
}
