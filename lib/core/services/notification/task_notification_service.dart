import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

class TaskNotificationService {
  static final TaskNotificationService _instance = TaskNotificationService._internal();
  factory TaskNotificationService() => _instance;
  TaskNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone database
      tz.initializeTimeZones();

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for Android 13+
      await _requestPermissions();

      _isInitialized = true;
      log('[TaskNotificationService] Initialized successfully');
    } catch (e, stackTrace) {
      log(
        '[TaskNotificationService] Error initializing: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Request notification permissions (Android 13+)
  Future<void> _requestPermissions() async {
    if (_notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    if (_notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>() !=
        null) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    log('[TaskNotificationService] Notification tapped: ${response.payload}');
    // You can navigate to specific screen here if needed
  }

  /// Schedule a notification for a task
  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (!_isInitialized) {
      log('[TaskNotificationService] Service not initialized, initializing now...');
      await initialize();
    }

    // Only schedule if task has both dueDate and dueTime
    if (task.id == null || task.dueDate == null || task.dueTime == null) {
      log('[TaskNotificationService] Cannot schedule notification: missing id, dueDate or dueTime');
      return;
    }

    try {
      // Combine dueDate and dueTime
      final scheduledDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
        task.dueTime!.hour,
        task.dueTime!.minute,
      );

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

      await _notificationsPlugin.zonedSchedule(
        task.id!, // Use task ID as notification ID
        'Lembrete: ${task.title}',
        task.description ?? 'Você tem uma tarefa pendente',
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: task.id.toString(),
      );

      log('[TaskNotificationService] Notification scheduled for task ${task.id} at $scheduledDate');
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
}
