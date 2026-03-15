import 'dart:convert';
import 'dart:developer';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/task_details_bottom_sheet.dart';

/// Service to handle navigation from notification taps
class NotificationNavigationService {
  static final NotificationNavigationService _instance = 
      NotificationNavigationService._internal();
  factory NotificationNavigationService() => _instance;
  NotificationNavigationService._internal();

  /// Handle notification tap and navigate to task details
  Future<void> handleNotificationTap(String? payload) async {
    if (payload == null || payload.isEmpty) {
      log('[NotificationNavigationService] Empty payload received');
      return;
    }

    try {
      log('[NotificationNavigationService] 🔔 Processing notification tap');
      log('[NotificationNavigationService]    - Payload: $payload');

      // Parse payload
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final taskId = data['taskId'] as int?;
      final boardId = data['boardId'] as int?;

      if (taskId == null) {
        log('[NotificationNavigationService] ❌ Task ID not found in payload');
        return;
      }

      log('[NotificationNavigationService]    - Task ID: $taskId');
      log('[NotificationNavigationService]    - Board ID: $boardId');

      // Get task from repository
      final taskRepository = getIt<TaskRepository>();
      final taskResult = await taskRepository.getTaskById(taskId);

      // Try to extract task value
      dynamic task;
      try {
        // Access value property if it's a Success
        task = (taskResult as dynamic).value;
      } catch (e) {
        log('[NotificationNavigationService] ❌ Error accessing task: $e');
        return;
      }
      
      if (task == null) {
        log('[NotificationNavigationService] ❌ Task not found: $taskId');
        return;
      }

      log('[NotificationNavigationService] ✅ Task found: ${task.title}');
      
      // Get navigator context
      final context = AppNavigation.router.routerDelegate.navigatorKey.currentContext;
      
      if (context == null) {
        log('[NotificationNavigationService] ❌ Navigator context is null');
        return;
      }

      // Navigate to tasks page
      AppNavigation.navigateToTasks(context);

      // Wait for navigation to complete and page to be ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Get context again after navigation
      final currentContext = AppNavigation.router.routerDelegate.navigatorKey.currentContext;
      
      if (currentContext == null || !currentContext.mounted) {
        log('[NotificationNavigationService] ❌ Context not mounted after navigation');
        return;
      }

      // Show task details bottom sheet
      log('[NotificationNavigationService] 📋 Opening task details bottom sheet');
      TaskDetailsBottomSheet.show(
        context: currentContext,
        task: task,
      );

      log('[NotificationNavigationService] ✅ Navigation completed successfully');
    } catch (e, stackTrace) {
      log(
        '[NotificationNavigationService] ❌ Error handling notification tap: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Create notification payload with task and board info
  static String createPayload({
    required int taskId,
    required int? boardId,
  }) {
    final payload = jsonEncode({
      'taskId': taskId,
      'boardId': boardId,
    });
    return payload;
  }
}
