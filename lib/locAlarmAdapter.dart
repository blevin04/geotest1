import 'package:geofence_foreground_service/exports.dart';
import 'package:hive/hive.dart';

part 'locAlarmAdapter.g.dart';

@HiveType(typeId: 1) // Give a unique ID

class locAlarm extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<LatLng> points;

  @HiveField(2)
  bool isCircle;

  @HiveField(3)
  double radius;

  @HiveField(4)
  String message;

  @HiveField(5)
  Map attachments;

  locAlarm(
      {required this.attachments,
      required this.id,
      required this.isCircle,
      required this.message,
      required this.points,
      required this.radius});
}
