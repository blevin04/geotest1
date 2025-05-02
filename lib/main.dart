import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geotest1/geofenceHandler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geotest1/locAlarmAdapter.dart';
import 'package:geotest1/notificationHander.dart';
import 'package:geotest1/pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPlatformState();
  await Hive.initFlutter();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Hive.registerAdapter(locAlarmNAdapter());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    Hive.openBox("LocAlarms");
    var port = ReceivePort();
    var portN = IsolateNameServer.lookupPortByName("EventChange");
    if (portN == null) {
      IsolateNameServer.registerPortWithName(port.sendPort, "EventChange");
    }

    port.listen(onDone: () {
      // print("ok mtf");
    }, (dynamic data) async {
      // print(data);
      String locId = data.first;
      await Hive.openBox("LocAlarms");
      var allLocs = Hive.box("LocAlarms").toMap();
      allLocs.forEach((key, value) async {
        if (value.id == locId) {
          List<String> attch = value.attachments;
          String imgs = "";

          attch.forEach((value0) {
            if (value0.endsWith("jpg") ||
                value0.endsWith("png") ||
                value0.endsWith("jpeg")) {
              imgs = (value);
            }
          });
          String action = data.last;
          await showNotification("$action Location!", value.message, imgs);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
