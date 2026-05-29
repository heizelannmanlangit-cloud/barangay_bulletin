import 'package:barangay_bulletin/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/announcement.dart';
import 'models/issue_report.dart';
import 'constants/app_colors.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AnnouncementAdapter());
  Hive.registerAdapter(IssueReportAdapter());
  await Hive.openBox<Announcement>('announcements');
  await Hive.openBox<IssueReport>('issue_reports');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Barangay Bulletin",
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.olive),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.olive,
          foregroundColor: AppColors.cream,
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.olive,
          foregroundColor: Colors.white,
          ),
           elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.olive,
            foregroundColor: Colors.white,
            ),
          ),
      ),

      home: const MainScreen(),
    );
  }


}