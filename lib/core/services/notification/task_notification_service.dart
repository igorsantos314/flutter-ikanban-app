import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/core/services/permission/permission_service.dart';

class TaskNotificationService {
  static final TaskNotificationService _instance = TaskNotificationService._internal();
  factory TaskNotificationService() => _instance;
  TaskNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final PermissionService _permissionService = PermissionService();

  bool _isInitialized = false;

  // Android notification limit
  static const int _androidNotificationLimit = 500;
  static const int _notificationWarningThreshold = 450; // Aviso aos 90%

  /// Initialize the notification service (without requesting permissions)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone database
      tz.initializeTimeZones();

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

      // iOS initialization settings (don't request permissions automatically)
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      log('[TaskNotificationService] Initialized successfully (permissions not requested yet)');
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error initializing: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Request notification permissions with rationale support
  /// Returns true if permission was granted
  Future<bool> requestPermissions({BuildContext? context}) async {
    if (!_isInitialized) {
      await initialize();
    }

    final result = await _permissionService.requestPermission(
      PermissionType.notification,
      context: context,
      rationaleTitle: 'Permissão de Notificações',
      rationaleMessage:
          'O iKanban precisa de permissão para enviar notificações e lembrá-lo sobre suas tarefas. '
          'Sem essa permissão, você não receberá lembretes das suas tarefas agendadas.',
    );

    final granted = result == PermissionRequestResult.granted;
    log('[TaskNotificationService] Permission request result: $granted');
    return granted;
  }

  /// Check if notification permissions are granted
  Future<bool> hasPermissions() async {
    if (!_isInitialized) return false;

    return await _permissionService.isPermissionGranted(
      PermissionType.notification,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    log('[TaskNotificationService] Notification tapped: ${response.payload}');
    // You can navigate to specific screen here if needed
  }

  /// Schedule a notification for a task
  /// 
  /// IMPORTANT NOTES:
  /// - Notifications are AUTOMATICALLY removed from pending queue after being displayed
  /// - Android has a limit of 500 scheduled notifications per app
  /// - Use scheduleTaskNotificationSafe() to check limit before scheduling
  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (!_isInitialized) {
      log('[TaskNotificationService] Service not initialized, initializing now...');
      await initialize();
    }

    // Only schedule if shouldNotify is true and task has both dueDate and dueTime
    if (!task.shouldNotify) {
      log('[TaskNotificationService] Task notification disabled by user');
      return;
    }

    if (task.id == null || task.dueDate == null || task.dueTime == null) {
      log('[TaskNotificationService] Cannot schedule notification: missing id, dueDate or dueTime');
      return;
    }

    try {
      // Combine dueDate and dueTime
      final taskDateTime = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
        task.dueTime!.hour,
        task.dueTime!.minute,
      );

      // Calculate notification time based on notifyMinutesBefore
      final minutesBefore = task.notifyMinutesBefore ?? 0;
      final scheduledDate = taskDateTime.subtract(Duration(minutes: minutesBefore));

      // Don't schedule if the time has already passed
      if (scheduledDate.isBefore(DateTime.now())) {
        log('[TaskNotificationService] Cannot schedule notification: time has passed');
        return;
      }

      const androidDetails = AndroidNotificationDetails(
        'task_reminders',
        'Lembretes de Tarefas',
        channelDescription: 'Notificações para lembrar de tarefas pendentes',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Build notification message based on minutesBefore
      String notificationBody;
      if (minutesBefore > 0) {
        final hours = minutesBefore ~/ 60;
        final minutes = minutesBefore % 60;
        String timeText = '';
        if (hours > 0) {
          timeText += '$hours hora${hours > 1 ? 's' : ''}';
          if (minutes > 0) timeText += ' e ';
        }
        if (minutes > 0) {
          timeText += '$minutes minuto${minutes > 1 ? 's' : ''}';
        }
        notificationBody = task.description?.isNotEmpty == true
            ? '${task.description} (em $timeText)'
            : 'Tarefa agendada para daqui a $timeText';
      } else {
        notificationBody = task.description ?? 'Você tem uma tarefa pendente';
      }

      await _notificationsPlugin.zonedSchedule(
        task.id!, // Use task ID as notification ID
        'Lembrete: ${task.title}',
        notificationBody,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: task.id.toString(),
      );

      log('[TaskNotificationService] Notification scheduled for task ${task.id} at $scheduledDate ($minutesBefore minutes before task time)');
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error scheduling notification: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cancel a task notification
  Future<void> cancelTaskNotification(int taskId) async {
    if (!_isInitialized) {
      log('[TaskNotificationService] Service not initialized');
      return;
    }

    try {
      await _notificationsPlugin.cancel(taskId);
      log('[TaskNotificationService] Notification cancelled for task $taskId');
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error cancelling notification: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) {
      log('[TaskNotificationService] Service not initialized');
      return;
    }

    try {
      await _notificationsPlugin.cancelAll();
      log('[TaskNotificationService] All notifications cancelled');
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error cancelling all notifications: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if a notification exists for a task
  Future<bool> hasNotification(int taskId) async {
    if (!_isInitialized) return false;

    try {
      final pendingNotifications =
          await _notificationsPlugin.pendingNotificationRequests();
      return pendingNotifications.any((notification) => notification.id == taskId);
    } catch (e) {
      log('[TaskNotificationService] Error checking notification: $e');
      return false;
    }
  }

  /// Get count of pending notifications
  Future<int> getPendingNotificationsCount() async {
    if (!_isInitialized) return 0;

    try {
      final pendingNotifications =
          await _notificationsPlugin.pendingNotificationRequests();
      final count = pendingNotifications.length;
      log('[TaskNotificationService] Pending notifications count: $count');
      return count;
    } catch (e) {
      log('[TaskNotificationService] Error getting pending count: $e');
      return 0;
    }
  }

  /// Check if we're close to Android's notification limit
  Future<bool> isNearNotificationLimit() async {
    final count = await getPendingNotificationsCount();
    return count >= _notificationWarningThreshold;
  }

  /// Check if we've reached Android's notification limit
  Future<bool> hasReachedNotificationLimit() async {
    final count = await getPendingNotificationsCount();
    return count >= _androidNotificationLimit;
  }

  /// Clean expired notifications (past scheduled time but still pending)
  /// This can happen if the device was off or app wasn't running
  Future<int> cleanExpiredNotifications() async {
    if (!_isInitialized) {
      log('[TaskNotificationService] Service not initialized');
      return 0;
    }

    try {
      final pendingNotifications =
          await _notificationsPlugin.pendingNotificationRequests();
      int cleanedCount = 0;

      // Note: flutter_local_notifications doesn't provide scheduled time directly
      // We can only cancel all and let tasks reschedule, or track separately
      // For now, we'll log the count
      
      log('[TaskNotificationService] Total pending notifications: ${pendingNotifications.length}');
      log('[TaskNotificationService] Consider manual cleanup if count is too high');
      
      // Future improvement: Store scheduled times in a database to enable
      // proper expired notification cleanup
      
      return cleanedCount;
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error cleaning expired notifications: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  /// Get all pending notifications info (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) return [];

    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      log('[TaskNotificationService] Error getting pending notifications: $e');
      return [];
    }
  }

  /// Schedule with limit check
  Future<NotificationScheduleResult> scheduleTaskNotificationSafe(TaskModel task) async {
    // Check if we've reached the limit
    if (await hasReachedNotificationLimit()) {
      log('[TaskNotificationService] Notification limit reached! Cannot schedule more.');
      return NotificationScheduleResult.limitReached;
    }

    // Warn if near limit
    if (await isNearNotificationLimit()) {
      log('[TaskNotificationService] Warning: Near notification limit (${await getPendingNotificationsCount()}/$_androidNotificationLimit)');
      // Consider cleaning up old notifications
      await cleanExpiredNotifications();
    }

    // Schedule the notification
    await scheduleTaskNotification(task);
    
    return NotificationScheduleResult.success;
  }
}

/// Result of notification scheduling operation
enum NotificationScheduleResult {
  success,
  limitReached,
  permissionDenied,
  error,
}
