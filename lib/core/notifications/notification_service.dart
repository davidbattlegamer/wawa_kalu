import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _channelId =
      'wawa_kalu_vaccines';

  static const String _channelName =
      'Recordatorios de vacunas';

  static const String _channelDescription =
      'Recordatorios del esquema de vacunación infantil.';

  Future<void> initialize() async {
    if (_initialized || kIsWeb) {
      return;
    }

    tz.initializeTimeZones();

    try {
      final timezone =
          await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(
          timezone.identifier,
        ),
      );
    } catch (_) {
      // Wawa Kalú está orientada al esquema de Ecuador.
      // Solo se usa como respaldo si el sistema no entrega
      // correctamente la zona horaria.
      tz.setLocalLocation(
        tz.getLocation(
          'America/Guayaquil',
        ),
      );
    }

    const AndroidInitializationSettings android =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const IOSInitializationSettings ios =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const DarwinInitializationSettings macOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const LinuxInitializationSettings linux =
        LinuxInitializationSettings(
      defaultActionName: 'Abrir Wawa Kalú',
    );

    const WindowsInitializationSettings windows =
        WindowsInitializationSettings(
      appName: 'Wawa Kalú',
      appUserModelId: 'WawaKalu.WawaKalu',
      guid:
          '6e8d734b-f79e-4e76-9de4-0f8838dcda4d',
    );

    const InitializationSettings settings =
        InitializationSettings(
      android: android,
      iOS: ios,
      macOS: macOS,
      linux: linux,
      windows: windows,
    );

    await _plugin.initialize(
      settings: settings,
    );

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) {
      return false;
    }

    await initialize();

    final AndroidFlutterLocalNotificationsPlugin?
        android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final bool? granted =
          await android
              .requestNotificationsPermission();

      return granted ?? true;
    }

    final IOSFlutterLocalNotificationsPlugin? ios =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (ios != null) {
      final bool? granted =
          await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    final MacOSFlutterLocalNotificationsPlugin?
        macOS =
        _plugin.resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();

    if (macOS != null) {
      final bool? granted =
          await macOS.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    // Windows no utiliza el mismo diálogo de permiso.
    return true;
  }

  Future<void> schedule({
    required int id,
    required DateTime date,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      return;
    }

    await initialize();

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      9,
    );

    final tz.TZDateTime now =
        tz.TZDateTime.now(
      tz.local,
    );

    if (!scheduledDate.isAfter(now)) {
      return;
    }

    const NotificationDetails details =
        NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription:
            _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: WindowsNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancel(
    int id,
  ) async {
    if (kIsWeb) {
      return;
    }

    await initialize();

    await _plugin.cancel(
      id: id,
    );
  }

  Future<void> showTestNotification() async {
    if (kIsWeb) {
      return;
    }

    await initialize();

    const NotificationDetails details =
        NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription:
            _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );

    await _plugin.show(
      id: 987654,
      title: 'Wawa Kalú',
      body:
          'Las notificaciones están funcionando correctamente.',
      notificationDetails: details,
    );
  }
}