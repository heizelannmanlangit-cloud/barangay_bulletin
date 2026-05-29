import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/issue_report.dart';
import 'report_form_screen.dart';
import 'report_detail_screen.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {

  final Box<IssueReport> box = Hive.box<IssueReport>('issue_reports');

  String selectedStatus = "All";
  String selectedCategory = "All";

  final List<String> statusFilters = ["All", "Pending", "In Progress", "Resolved"];
  final List<String> categoryFilters = ["All", "Road", "Power", "Water", "Safety", "Other"];

  List<IssueReport> getVisibleReports() {
    List<IssueReport> visible = [];
    for (IssueReport r in box.values) {
      if (r.isDeleted == false){
        visible.add(r);
        }
    }

    if (selectedStatus != "All"){
      List<IssueReport> filtered = [];
      for (IssueReport r in visible) {
        if (r.status == selectedStatus){
          filtered.add(r);
        }
      }
      visible = filtered;
        }

    if (selectedCategory != "All"){
      List<IssueReport> filtered = [];
      for (IssueReport r in visible) {
        if (r.category == selectedCategory){
          filtered.add(r);
          }
      }
      visible = filtered;
    }

    visible.sort((a, b) => b.dateReported.compareTo(a.dateReported));

    return visible;
  }

  void openCreateForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportFormScreen(existing: null),
          ),
    );

    if (result != null){
      box.put(result.id, result);
      setState(() {});
    }
  }

  void openDetail(IssueReport r) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(report: r),
        ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<IssueReport> reports = getVisibleReports();

    return Scaffold(
      appBar: AppBar(title: Text("Reports")),

      floatingActionButton: FloatingActionButton(
        onPressed: openCreateForm,
        child: Icon(Icons.add),
          ),

      body: Column(
        children: [
          buildStatusFilterBar(),

          buildCategoryDropdown(),

          Expanded(
            child: buildBody(reports),
            ),
        ],
      ),
    );
  }

  Widget buildStatusFilterBar() {
    List<Widget> buttons = [];
    for (String s in statusFilters) {
      buttons.add(buildStatusButton(s));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(12),
      child: Row(children: buttons),
        );
  }

  Widget buildStatusButton(String status) {
    Color bg = AppColors.warmSand;
    Color fg = AppColors.ink;

    if (selectedStatus == status){
      bg = AppColors.olive;
      fg = Colors.white;
      }

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedStatus = status;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
            ),
        child: Text(status),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (String c in categoryFilters) {
      items.add(DropdownMenuItem(value: c, child: Text(c)));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text("Category: ", style: TextStyle(fontWeight: FontWeight.w600)),
          DropdownButton<String>(
            value: selectedCategory,
            items: items,
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
              ),
        ],
      ),
    );
  }

  Widget buildBody(List<IssueReport> reports) {
    if (reports.isEmpty){
      String message = "No reports yet.\nTap + to log an issue.";
      if (selectedStatus != "All" || selectedCategory != "All"){
        message = "No reports match these filters.";
      }

      return Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.stone),
            ),
      );
    }

    List<Widget> tiles = [];
    for (IssueReport r in reports) {
      tiles.add(buildReportTile(r));
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: tiles,
    );
  }

  Widget buildReportTile(IssueReport r) {
    return GestureDetector(
      onTap: () {
        openDetail(r);
      },
      child: Container(
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
              r.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),

            SizedBox(height: 6),

            Row(
              children: [
                buildStatusBadge(r.status),

                SizedBox(width: 8),

                Text(r.category, style: TextStyle(fontSize: 12)),

                SizedBox(width: 8),

                Text(
                  DateFormat('MMM d, y').format(r.dateReported),
                  style: TextStyle(fontSize: 12, color: AppColors.stone),
                ),
              ],
                ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusBadge(String status) {
    Color color = getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
          ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Color getStatusColor(String status) {
    if (status == "Pending"){
      return AppColors.pending;
    }
    if (status == "In Progress"){
      return AppColors.inProgress;
    }
    return AppColors.resolved;
  }
}