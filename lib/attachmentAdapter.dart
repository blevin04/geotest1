import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';

part 'attachmentAdapter.g.dart'; // Needed for code generation

@HiveType(typeId: 0) // Give a unique ID
class Attachments extends HiveObject {
  @HiveField(0)
  final FileType type;

  @HiveField(1)
  final String path;

  Attachments({required this.type, required this.path});
}
