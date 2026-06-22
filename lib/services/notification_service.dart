import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String _bookmarkChannelKey = 'bookmark_alerts';

  int _idForSpot(String spotId) => spotId.hashCode.abs() % 2147483647;

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: _bookmarkChannelKey,
          channelName: 'Bookmark Alerts',
          channelDescription:
              'Notifies spot owners when someone saves their spot.',
          defaultColor: const Color(0xFF1D9E75),
          ledColor: const Color(0xFF1D9E75),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: false,
    );

    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> onBookmarkToggled({
    required String spotId,
    required String spotName,
    required String ownerId,
    required bool wasAdded,
  }) async {
    if (!wasAdded) return;

    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _idForSpot(spotId),
        channelKey: _bookmarkChannelKey,
        title: '📍 Someone saved your spot!',
        body: '"$spotName" was added to a user\'s saved spots.',
        notificationLayout: NotificationLayout.Default,
        payload: {
          'spotId': spotId,
          'ownerId': ownerId,
        },
      ),
    );
  }
}