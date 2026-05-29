import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/issue_report.dart';
import 'report_form_screen.dart';

class ReportDetailScreen extends StatefulWidget {
  final IssueReport report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {

  final Box<IssueReport> box = Hive.box<IssueReport>('issue_reports');

  final List<String> statuses = ["Pending", "In Progress", "Resolved"];

  void openEditForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportFormScreen(existing: widget.report),
          ),
    );

    if (result != null){
      box.put(result.id, result);
      setState(() {});
    }
  }

  void changeStatus(String newStatus) {
    setState(() {
      widget.report.status = newStatus;
    });

    box.put(widget.report.id, widget.report);
  }

  void softDelete() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete report?"),
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
      widget.report.isDeleted = true;
      widget.report.deletedAt = DateTime.now();
      box.put(widget.report.id, widget.report);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    IssueReport r = widget.report;

    List<DropdownMenuItem<String>> statusItems = [];
    for (String s in statuses) {
      statusItems.add(DropdownMenuItem(value: s, child: Text(s)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: [
          IconButton(onPressed: openEditForm, icon: Icon(Icons.edit)),
          IconButton(onPressed: softDelete, icon: Icon(Icons.delete)),
        ],
          ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            r.title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),

          SizedBox(height: 12),

          Row(
            children: [
              Text("Category: ", style: TextStyle(fontWeight: FontWeight.w600)),
              Text(r.category),

              SizedBox(width: 16),

              Text(
                DateFormat('MMM d, y').format(r.dateReported),
                style: TextStyle(color: AppColors.stone),
              ),
            ],
              ),

          SizedBox(height: 20),

          Text(r.description, style: TextStyle(fontSize: 16)),

          SizedBox(height: 28),

          Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),

          SizedBox(height: 6),

          DropdownButtonFormField<String>(
            initialValue: r.status,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
                ),
            items: statusItems,
            onChanged: (value) {
              changeStatus(value!);
            },
          ),
        ],
      ),
    );
  }
}