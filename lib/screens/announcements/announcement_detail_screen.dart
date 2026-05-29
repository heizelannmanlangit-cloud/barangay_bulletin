import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/announcement.dart';
import 'announcement_form_screen.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {

  final Box<Announcement> box = Hive.box<Announcement>('announcements');

  void openEditForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementFormScreen(existing: widget.announcement),
      ),
    );

    if (result != null){
      box.put(result.id, result);
      setState(() {});
    }
  }

  void togglePin() {
    setState(() {
      if (widget.announcement.isPinned == true){
        widget.announcement.isPinned = false;
      }
      else{
        widget.announcement.isPinned = true;
      }
    });

    box.put(widget.announcement.id, widget.announcement);
  }

  void softDelete() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete announcement?"),
          content: Text("It will be moved to the Archive."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmed == true){
      widget.announcement.isDeleted = true;
      widget.announcement.deletedAt = DateTime.now();
      box.put(widget.announcement.id, widget.announcement);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Announcement a = widget.announcement;

    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement"),
        actions: [
          IconButton(onPressed: openEditForm, icon: Icon(Icons.edit)),
          IconButton(onPressed: softDelete, icon: Icon(Icons.delete)),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            a.title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warmSand,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(a.category, style: TextStyle(color: AppColors.ink)),
              ),

              SizedBox(width: 10),

              Text(
                DateFormat('MMM d, y').format(a.datePosted),
                style: TextStyle(color: AppColors.stone),
              ),
            ],
          ),

          SizedBox(height: 20),

          Text(a.body, style: TextStyle(fontSize: 16)),

          SizedBox(height: 28),

          buildPinButton(a),
        ],
      ),
    );
  }

  Widget buildPinButton(Announcement a) {
    String label = "Pin this announcement";
    if (a.isPinned == true){
      label = "Unpin this announcement";
    }

    return ElevatedButton.icon(
      onPressed: togglePin,
      icon: Icon(Icons.push_pin),
      label: Text(label),
    );
  }
}