// import 'package:geofence_foreground_service/exports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geotest1/locAlarmAdapter.dart';
import 'package:geotest1/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' hide LatLng;
import 'package:permission_handler/permission_handler.dart';

final location0 = Location();

Future<List> currentLocation() async {
  List currPos = List.empty(growable: true);
  LocationData locationData = await location0.getLocation();
  currPos.add(locationData.latitude);
  currPos.add(locationData.longitude);
  return currPos;
}

showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<Attachment> getContent(BuildContext context, FileType filetype) async {
  String content = "";
  Permission.accessMediaLocation.onDeniedCallback(() async {
    Permission.accessMediaLocation.request();
    if (await Permission.accessMediaLocation.isDenied) {
      showsnackbar(context, "Permission denied");
    }
    if (await Permission.accessMediaLocation.isGranted) {
      showsnackbar(context, 'Granted');
    }
  });

  FilePickerResult? result = (await FilePicker.platform
      .pickFiles(type: filetype, allowMultiple: false));
  FileType newl = FileType.values[0];
  if (result != null) {
    content = result.files.single.path!;
    if (content.endsWith("png") ||
        content.endsWith("jpeg") ||
        content.endsWith("jpg")) {
      newl = FileType.image;
    }
    if (content.endsWith("mp4")) {
      newl = FileType.video;
    }
    if (content.endsWith("docs") || content.endsWith("pdf")) {
      newl = FileType.values[104];
    }
    if (content.endsWith("mp3")) {
      newl = FileType.audio;
    }
    // setState(() {});
  }
  if (result == null) {
    showsnackbar(context, 'no file chossen');
  }
  return Attachment(fileType: newl, path: content);
}

void showcircularProgressIndicator(BuildContext context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
}

Future<int> addLocAlarm(locAlarm newLoc) async {
  await Hive.openBox("LocAlarms");
  if (Hive.box("LocAlarms").isOpen) {
    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
    locAlarmN locNew = locAlarmN(
        attachments: newLoc.attachments,
        id: newLoc.id,
        isCircle: newLoc.isCircle,
        message: newLoc.message,
        points: List.generate(newLoc.points.length, (index) {
          return [
            newLoc.points[index].latitude,
            newLoc.points[index].longitude
          ];
        }),
        radius: newLoc.radius);
    Box localarmsBox = Hive.box("LocAlarms");
    localarmsBox.add(locNew);
    return 0;
  }
  return 1;
}
