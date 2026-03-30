
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/core/services/permission/permission_service.dart';
import 'package:flutter_ikanban_app/core/services/notification/notification_navigation_service.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';

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
    if (_isInitialized) {
      return;
    }

    try {
      // Initialize timezone database
      tz.initializeTimeZones();
      
      // Set local timezone
      final locationName = 'America/Sao_Paulo'; // or get from system
      try {
        tz.setLocalLocation(tz.getLocation(locationName));
      } catch (e) {
        // Use UTC as fallback
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

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
    } catch (e) {
      // Handle initialization error silently
      debugPrint('Error initializing notification service: $e');
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
    return granted;
  }

  /// Check if notification permissions are granted
  Future<bool> hasPermissions() async {
    if (!_isInitialized) return false;

    return await _permissionService.isPermissionGranted(
      PermissionType.notification,
    );
  }

  /// Check if the app can schedule exact alarms (Android 12+)
  /// Returns true on iOS or if the permission is granted on Android
  Future<bool> canScheduleExactAlarms() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation == null) {
        // iOS or other platform
        return true;
      }

      final canSchedule = await androidImplementation.canScheduleExactNotifications();
      return canSchedule ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Request exact alarm permission (Android 12+)
  /// Opens system settings for the user to grant the permission
  Future<bool> requestExactAlarmPermission() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation == null) {
        // iOS or other platform - no need to request
        return true;
      }

      // Check if already granted
      final canSchedule = await androidImplementation.canScheduleExactNotifications();
      if (canSchedule == true) {
        return true;
      }

      // Request the permission - this opens system settings
      await androidImplementation.requestExactAlarmsPermission();
      
      // Check again after user returns
      final newStatus = await androidImplementation.canScheduleExactNotifications();
      return newStatus ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check all required permissions for notifications to work properly
  Future<NotificationPermissionStatus> checkAllPermissions() async {
    final hasNotificationPermission = await hasPermissions();
    final canScheduleExact = await canScheduleExactAlarms();

    return NotificationPermissionStatus(
      hasNotificationPermission: hasNotificationPermission,
      canScheduleExactAlarms: canScheduleExact,
    );
  }

  /// Request all required permissions for notifications
  /// Returns true if all permissions are granted
  Future<bool> requestAllPermissions({BuildContext? context}) async {
    // First request notification permission
    final notificationGranted = await requestPermissions(context: context);
    
    if (!notificationGranted) {
      return false;
    }

    // Then check/request exact alarm permission (Android 12+)
    final exactAlarmGranted = await requestExactAlarmPermission();
    
    if (!exactAlarmGranted) {
      // Still return true as notifications might work, just not precisely
    }

    return notificationGranted;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Use navigation service to handle the tap
    final navigationService = getIt<NotificationNavigationService>();
    navigationService.handleNotificationTap(response.payload);
  }

  /// Schedule a notification for a task
  /// 
  /// IMPORTANT NOTES:
  /// - Notifications are AUTOMATICALLY removed from pending queue after being displayed
  /// - Android has a limit of 500 scheduled notifications per app
  /// - Use scheduleTaskNotificationSafe() to check limit before scheduling
  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Only schedule if shouldNotify is true and task has both dueDate and dueTime
    if (!task.shouldNotify) {
      return;
    }

    if (task.id == null || task.dueDate == null || task.dueTime == null) {
      return;
    }

    // Verify permissions before scheduling
    final hasNotificationPermission = await hasPermissions();
    
    if (!hasNotificationPermission) {
      return;
    }

    // Check if can schedule exact alarms (Android 12+)
    final canScheduleExact = await canScheduleExactAlarms();
    
    if (!canScheduleExact) {
      // Continue anyway - notification will be scheduled but may be delayed by Doze mode
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
      final now = DateTime.now();
      
      if (scheduledDate.isBefore(now)) {
        return;
      }

      // Convert to TZDateTime for zonedSchedule
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

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

      final notificationId = task.id!;
      
      await _notificationsPlugin.zonedSchedule(
        notificationId, // Use task ID as notification ID
        'Lembrete: ${task.title}',
        notificationBody,
        tzScheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: NotificationNavigationService.createPayload(
          taskId: task.id!,
          boardId: task.boardId,
        ),
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel a task notification
  Future<void> cancelTaskNotification(int taskId) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _notificationsPlugin.cancel(taskId);
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
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
      return count;
    } catch (e) {
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
      return 0;
    }

    try {
      // Note: flutter_local_notifications doesn't provide scheduled time directly
      // We can only cancel all and let tasks reschedule, or track separately
      // Future improvement: Store scheduled times in a database to enable
      // proper expired notification cleanup
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get all pending notifications info (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) {
      return [];
    }

    try {
      final pendingNotifications = await _notificationsPlugin.pendingNotificationRequests();
      return pendingNotifications;
    } catch (e) {
      return [];
    }
  }

  /// Schedule with limit check
  Future<NotificationScheduleResult> scheduleTaskNotificationSafe(TaskModel task) async {
    // Check if we've reached the limit
    if (await hasReachedNotificationLimit()) {
      return NotificationScheduleResult.limitReached;
    }

    // Warn if near limit
    if (await isNearNotificationLimit()) {
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

/// Status of all notification-related permissions
class NotificationPermissionStatus {
  final bool hasNotificationPermission;
  final bool canScheduleExactAlarms;

  NotificationPermissionStatus({
    required this.hasNotificationPermission,
    required this.canScheduleExactAlarms,
  });

  /// Returns true if all permissions are granted for reliable notifications
  bool get allGranted => hasNotificationPermission && canScheduleExactAlarms;

  /// Returns true if at least notification permission is granted
  /// (notifications might still work but may be delayed by Doze mode)
  bool get canShowNotifications => hasNotificationPermission;

  @override
  String toString() {
    return 'NotificationPermissionStatus('
        'hasNotificationPermission: $hasNotificationPermission, '
        'canScheduleExactAlarms: $canScheduleExactAlarms)';
  }
}
