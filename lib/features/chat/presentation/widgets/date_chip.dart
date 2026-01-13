import 'package:flutter/material.dart';

class DateChip extends StatelessWidget {
  final String date;

  const DateChip({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF536979).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
