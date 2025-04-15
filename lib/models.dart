import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class locAlarm {
  String id;
  List<LatLng> points;
  bool isCircle;
  double radius;
  String message;
  Map attachments;

  locAlarm(
      {required this.attachments,
      required this.id,
      required this.isCircle,
      required this.message,
      required this.points,
      required this.radius});
}

class Attachment {
  String path;
  FileType fileType;

  Attachment({required this.fileType, required this.path});
}
