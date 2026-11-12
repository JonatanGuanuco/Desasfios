import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacionesService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      cuerpo,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_asistencia',
          'Asistencia',
          channelDescription: 'Avisos de asistencia',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}