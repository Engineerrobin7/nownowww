import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedInteractiveIcon extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final Color? color;
  final Color? activeColor;
  final VoidCallback onTap;
  final String label;

  const AnimatedInteractiveIcon({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    this.color,
    this.activeColor,
    required this.onTap,
    required this.label,
  });

  @override
  State<AnimatedInteractiveIcon> createState() => _AnimatedInteractiveIconState();
}

class _AnimatedInteractiveIconState extends State<AnimatedInteractiveIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                widget.isActive ? widget.activeIcon : widget.icon,
                size: 20,
                color: widget.isActive ? (widget.activeColor ?? Colors.red) : (widget.color ?? Colors.grey.shade600),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
