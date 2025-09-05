import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final bool enabled;

  const ControlButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color = Colors.white,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: enabled 
              ? color.withOpacity(0.1) 
              : color.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled 
              ? color 
              : color.withOpacity(0.3),
          size: size,
        ),
      ),
    );
  }
}