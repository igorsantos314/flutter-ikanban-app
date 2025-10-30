import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';

void showCustomSnackBar(
  BuildContext context, 
  String message, 
  NotificationType type
) {
  final colorScheme = Theme.of(context).colorScheme;
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case NotificationType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case NotificationType.error:
      backgroundColor = colorScheme.error;
      icon = Icons.error;
      break;
    case NotificationType.warning:
      backgroundColor = Colors.orange;
      icon = Icons.warning;
      break;
    case NotificationType.info:
      backgroundColor = colorScheme.primary;
      icon = Icons.info;
      break;
  }

  Future.microtask(() {
    if (!context.mounted) { return; }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating, // Faz o snackbar flutuar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  });
}
