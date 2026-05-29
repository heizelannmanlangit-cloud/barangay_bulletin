import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'announcements/announcement_list_screen.dart';
import 'reports/report_list_screen.dart';
import 'archive/archive_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int currentIndex = 0;

   final List<Widget> screens = const [
    AnnouncementsListScreen(),
    ReportsListScreen(),
    ArchiveScreen(),
   ];

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.warmWhite,
        selectedItemColor: AppColors.olive,
        unselectedItemColor: AppColors.stone,
        onTap: (index) {
            setState(() {
              currentIndex = index;
            });
        },

        items: [BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Announcements"),
        BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: "Reports"),
        BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archive"),
        ],


      ),

    );

   }




}