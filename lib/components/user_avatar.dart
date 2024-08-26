import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String userId;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.userId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const CircleAvatar(
        backgroundColor:
            Color.fromARGB(255, 218, 199, 243),
        child: Icon(
          Icons.person, // Default user icon
          size: 24,
          color: Colors.white, // Color of the icon
        ),
      ),
    );
  }
}
