import 'dart:developer';
import 'dart:ui';

import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/exports.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:permission_handler/permission_handler.dart' as permission0;

// This method is a top level method
@pragma('vm:entry-point')
void callbackDispatcher() async {
  // void send(var data0) {}

  GeofenceForegroundService().handleTrigger(
    backgroundTriggerHandler: (zoneID, triggerType) {
      final sendPort = IsolateNameServer.lookupPortByName("EventChange");
      log(zoneID, name: 'zoneID');
      if (triggerType == GeofenceEventType.enter) {
        log('enter!', name: 'triggerType');
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.

          sendPort.send("entered");
          print("notdamn");
        } else {
          print("damn");
        }
      } else if (triggerType == GeofenceEventType.exit) {
        log('exit', name: 'triggerType');
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.
          print("notdamn");
          sendPort.send("exited");
        } else {
          print("damn");
        }
      } else if (triggerType == GeofenceEventType.dwell) {
        log('dwell', name: triggerType.name);
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.
          print("notdamn");
          sendPort.send("dwelling");
        } else {
          print("damn");
        }
      } else {
        log('unknown', name: 'triggerType');
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.
          print("notdamn");
          sendPort.send("unknownn");
        } else {
          print("damn");
        }
      }
      return Future.value(true);
    },
  );
}

final List<LatLng> timesSquarePolygon = [
  LatLng(Angle.degree(-0.599188), Angle.degree(37.888460)),
];

Future<void> initPlatformState() async {
  // Remember to handle permissions before initiating the plugin
  await permission0.Permission.location.request();
  await permission0.Permission.locationAlways.request();
  await permission0.Permission.notification.request();

  bool hasServiceStarted =
      await GeofenceForegroundService().startGeofencingService(
    contentTitle: 'Localarm is running background',
    contentText: 'This is to bring you prompt notifications on location change',
    notificationChannelId: 'com.app.geofencing_notifications_channel',
    serviceId: 525600,
    callbackDispatcher: callbackDispatcher,
  );

  if (hasServiceStarted) {
    await GeofenceForegroundService().addGeofenceZone(
      zone: Zone(
        id: 'zone#1_id',
        radius: 100, // measured in meters
        coordinates: timesSquarePolygon,
      ),
    );
  }
}
