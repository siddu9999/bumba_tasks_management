import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final TextStyle style;

  // Color Palette
  final Color primaryColor = const Color(0xFF6c5ce7); // Purple
  final Color unselectedTextColor = const Color(0xFF2d3436); // Dark Gray

  TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? primaryColor : Colors.transparent, // Border color
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: style.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? primaryColor : unselectedTextColor, // Text color
          ),
        ),
      ),
    );
  }
}
