import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/announcement.dart';
import '../../models/issue_report.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {

  final Box<Announcement> announcementBox = Hive.box<Announcement>('announcements');
  final Box<IssueReport> reportBox = Hive.box<IssueReport>('issue_reports');

  String filterType = "All";

  void restoreAnnouncement(Announcement a) {
    a.isDeleted = false;
    a.deletedAt = null;
    announcementBox.put(a.id, a);
    setState(() {});
  }

  void restoreReport(IssueReport r) {
    r.isDeleted = false;
    r.deletedAt = null;
    reportBox.put(r.id, r);
    setState(() {});
  }

  void hardDeleteAnnouncement(Announcement a) async {
    bool? confirmed = await showHardDeleteDialog();
    if (confirmed == true){
      announcementBox.delete(a.id);
      setState(() {});
        }
  }

  void hardDeleteReport(IssueReport r) async {
    bool? confirmed = await showHardDeleteDialog();
    if (confirmed == true){
      reportBox.delete(r.id);
      setState(() {});
    }
  }

  Future<bool?> showHardDeleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete permanently?"),
          content: Text("This cannot be undone."),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Archive")),

      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                buildFilterButton("All"),
                buildFilterButton("Announcements"),
                buildFilterButton("Reports"),
              ],
                ),
          ),

          Expanded(
            child: buildBody(),
            ),
        ],
      ),
    );
  }

  Widget buildBody() {
    List<Widget> tiles = [];

    if (filterType == "All" || filterType == "Announcements"){
      for (Announcement a in announcementBox.values) {
        if (a.isDeleted == true){
          tiles.add(buildAnnouncementTile(a));
          }
      }
    }

    if (filterType == "All" || filterType == "Reports"){
      for (IssueReport r in reportBox.values) {
        if (r.isDeleted == true){
          tiles.add(buildReportTile(r));
        }
      }
        }

    if (tiles.isEmpty){
      return Center(
        child: Text(
          "Nothing in the archive",
          style: TextStyle(fontSize: 16, color: AppColors.stone),
            ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: tiles,
    );
  }

  Widget buildFilterButton(String type) {
    Color bg = AppColors.warmSand;
    Color fg = AppColors.ink;

    if (filterType == type){
      bg = AppColors.olive;
      fg = Colors.white;
      }

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            filterType = type;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
            ),
        child: Text(type),
      ),
    );
  }

  Widget buildAnnouncementTile(Announcement a) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 3),
              ),
        ],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Announcement",
            style: TextStyle(fontSize: 12, color: AppColors.sage, fontWeight: FontWeight.w600),
              ),

          SizedBox(height: 4),

          Text(
            a.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 4),

          Text(
            "Deleted: " + DateFormat('MMM d, y').format(a.deletedAt!),
            style: TextStyle(fontSize: 12, color: AppColors.stone),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  restoreAnnouncement(a);
                },
                icon: Icon(Icons.restore),
                label: Text("Restore"),
                  ),

              SizedBox(width: 10),

              OutlinedButton.icon(
                onPressed: () {
                  hardDeleteAnnouncement(a);
                },
                icon: Icon(Icons.delete_forever),
                label: Text("Delete"),
              ),
            ],
              ),
        ],
      ),
    );
  }

  Widget buildReportTile(IssueReport r) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 3),
              ),
        ],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Report",
            style: TextStyle(fontSize: 12, color: AppColors.terracotta, fontWeight: FontWeight.w600),
              ),

          SizedBox(height: 4),

          Text(
            r.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 4),

          Text(
            "Deleted: " + DateFormat('MMM d, y').format(r.deletedAt!),
            style: TextStyle(fontSize: 12, color: AppColors.stone),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  restoreReport(r);
                },
                icon: Icon(Icons.restore),
                label: Text("Restore"),
                  ),

              SizedBox(width: 10),

              OutlinedButton.icon(
                onPressed: () {
                  hardDeleteReport(r);
                },
                icon: Icon(Icons.delete_forever),
                label: Text("Delete"),
              ),
            ],
              ),
        ],
      ),
    );
  }
}