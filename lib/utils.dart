// import 'package:geofence_foreground_service/exports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
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

Future<String> getContent(BuildContext context, FileType filetype) async {
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
  if (result != null) {
    content = result.files.single.path!;
    // setState(() {});
  }
  if (result == null) {
    showsnackbar(context, 'no file chossen');
  }
  return content;
}
