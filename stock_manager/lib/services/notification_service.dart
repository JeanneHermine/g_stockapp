import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/models/product.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Request permissions
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request notification permission
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint('Notification permission granted');
    } else {
      debugPrint('Notification permission denied');
    }
  }

  Future<void> showLowStockNotification(Product product) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'low_stock_channel',
      'Alertes Stock Faible',
      channelDescription: 'Notifications pour les produits en stock faible',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      product.id.hashCode,
      'Stock faible',
      '${product.name} est en rupture de stock (${product.quantity} restant)',
      platformChannelSpecifics,
    );
  }

  Future<void> showStockMovementNotification(String productName, int quantity, String type) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stock_movement_channel',
      'Mouvements de Stock',
      channelDescription: 'Notifications pour les mouvements de stock importants',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
      enableVibration: false,
      playSound: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final action = type == 'in' ? 'ajouté' : 'retiré';
    final message = '$quantity $productName $action du stock';

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch,
      'Mouvement de stock',
      message,
      platformChannelSpecifics,
    );
  }

  Future<void> checkAndNotifyLowStock() async {
    try {
      final lowStockProducts = await DatabaseHelper.instance.getLowStockProducts();

      for (final product in lowStockProducts) {
        // Check if we already notified recently (you might want to add a lastNotified field to Product model)
        await showLowStockNotification(product);
      }
    } catch (e) {
      debugPrint('Error checking low stock: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
