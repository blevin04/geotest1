import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showNotification(
    String title, String body, String imagePath) async {
  try {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    AndroidNotificationDetails messageTopreview = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: imagePath.isNotEmpty
          ? BigPictureStyleInformation(FilePathAndroidBitmap(imagePath))
          : null,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: messageTopreview);
    // print("daaaaaa");
    await FlutterLocalNotificationsPlugin()
        .show(0, title, body, platformChannelSpecifics);
    // print("nice");
  } catch (e) {
    print(e.toString());
  }
}
