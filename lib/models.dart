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
