// import 'package:geofence_foreground_service/exports.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';

final location0 = Location();

Future<List> currentLocation() async {
  List currPos = List.empty(growable: true);
  LocationData locationData = await location0.getLocation();
  currPos.add(locationData.latitude);
  currPos.add(locationData.longitude);
  return currPos;
}
