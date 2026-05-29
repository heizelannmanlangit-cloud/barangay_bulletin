import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/announcement.dart';
import 'announcement_form_screen.dart';
import 'announcement_detail_screen.dart';

class AnnouncementsListScreen extends StatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  State<AnnouncementsListScreen> createState() => _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends State<AnnouncementsListScreen> {

  final Box<Announcement> box = Hive.box<Announcement>('announcements');

  String selectedCategory = "All";
  final List<String> categoryFilters = ["All", "Info", "Event", "Emergency", "Health"];

  List<Announcement> getVisibleAnnouncements() {
    List<Announcement> visible = [];
    for (Announcement a in box.values) {
      if (a.isDeleted == false){
        visible.add(a);
      }
    }

    if (selectedCategory != "All"){
      List<Announcement> filtered = [];
      for (Announcement a in visible) {
        if (a.category == selectedCategory){
          filtered.add(a);
        }
      }
      visible = filtered;
    }

    visible.sort((a, b) => b.datePosted.compareTo(a.datePosted));

    List<Announcement> pinned = [];
    List<Announcement> notPinned = [];
    for (Announcement a in visible) {
      if (a.isPinned == true){
        pinned.add(a);
      }
      else{
        notPinned.add(a);
      }
    }

    return pinned + notPinned;
  }

  void openCreateForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementFormScreen(existing: null),
      ),
    );

    if (result != null){
      box.put(result.id, result);
      setState(() {});
    }
  }

  void openDetail(Announcement a) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailScreen(announcement: a),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Announcement> announcements = getVisibleAnnouncements();

    return Scaffold(
      appBar: AppBar(title: Text("Announcements")),

      floatingActionButton: FloatingActionButton(
        onPressed: openCreateForm,
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          buildFilterBar(),

          Expanded(
            child: buildBody(announcements),
          ),
        ],
      ),
    );
  }

  Widget buildFilterBar() {
    List<Widget> buttons = [];
    for (String c in categoryFilters) {
      buttons.add(buildFilterButton(c));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(12),
      child: Row(children: buttons),
    );
  }

  Widget buildFilterButton(String category) {
    Color bg = AppColors.warmSand;
    Color fg = AppColors.ink;

    if (selectedCategory == category){
      bg = AppColors.olive;
      fg = Colors.white;
    }

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
        ),
        child: Text(category),
      ),
    );
  }

  Widget buildBody(List<Announcement> announcements) {
    if (announcements.isEmpty){
      String message = "No announcements yet.\nTap + to post one.";
      if (selectedCategory != "All"){
        message = "No announcements in this category.";
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
    for (Announcement a in announcements) {
      tiles.add(buildAnnouncementTile(a));
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: tiles,
    );
  }

  Widget buildAnnouncementTile(Announcement a) {
    return GestureDetector(
      onTap: () {
        openDetail(a);
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(height: 6),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.warmSand,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(a.category, style: TextStyle(fontSize: 12, color: AppColors.ink)),
                      ),

                      SizedBox(width: 8),

                      Text(
                        DateFormat('MMM d, y').format(a.datePosted),
                        style: TextStyle(fontSize: 12, color: AppColors.stone),
                        ),
                       ],
                    ),
                  ],
                ),
            ),

            buildPinIcon(a),
            ],
          ),
        ),
      );
  }

  Widget buildPinIcon(Announcement a) {
    if (a.isPinned == true){
      return Icon(Icons.push_pin, size: 18, color: AppColors.terracotta);
    }
    return SizedBox();
  }
}