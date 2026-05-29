import 'package:hive/hive.dart';

part 'announcement.g.dart';

@HiveType(typeId: 0)

class Announcement extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;
  
  @HiveField(2)
  String body;

  @HiveField(3)
  String category; 

  @HiveField(4)
  DateTime datePosted;

  @HiveField(5)
  bool isPinned;

  @HiveField(6)
  bool isDeleted;

  @HiveField(7)
  DateTime? deletedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.datePosted,
    this.isPinned = false,
    this.isDeleted = false,
    this.deletedAt,
  });

}

