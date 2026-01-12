import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final String text;
  final double radius;
  final Color? backgroundColor;

  const Avatar({
    super.key,
    this.url,
    required this.text,
    this.radius = 24,
    this.backgroundColor,
  });

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  Color _getGenerateColor(String name) {
    if (backgroundColor != null) return backgroundColor!;
    return AppColors.primaryBlue;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getGenerateColor(text),
      child: url != null && url!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: url!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                ),
                errorWidget: (context, url, error) => _buildText(),
              ),
            )
          : _buildText(),
    );
  }

  Widget _buildText() {
    return Text(
      _getInitials(text),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: radius * 0.8,
      ),
    );
  }
}
