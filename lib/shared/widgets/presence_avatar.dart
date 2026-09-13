import 'package:flutter/material.dart';

class PresenceAvatar extends StatelessWidget {
  final String? photoUrl;
  final bool isOnline;
  final double radius;

  const PresenceAvatar({
    super.key,
    required this.photoUrl,
    required this.isOnline,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null ? Icon(Icons.person, color: Colors.grey, size: radius * 1.2) : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.6,
              height: radius * 0.6,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Standard online green
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
