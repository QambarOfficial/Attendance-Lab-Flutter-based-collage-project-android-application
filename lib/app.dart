import 'package:attendance_lab/screens/attendance_screen.dart';
import 'package:attendance_lab/screens/history_screen.dart';
import 'package:attendance_lab/screens/notifications_screen.dart';
import 'package:attendance_lab/screens/profile_screen.dart';
import 'package:attendance_lab/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: isLoggedIn ? Routes.home : Routes.login,
      routes: {
        Routes.login: (_) => const LoginScreen(),
        Routes.home: (_) => const HomeScreen(),
        Routes.attendance: (_) => const AttendanceScreen(),
        Routes.history: (_) => const HistoryScreen(),
        Routes.notifications: (_) => const NotificationsScreen(),
        Routes.profile: (_) => const ProfileScreen(),
        Routes.settings: (_) => const SettingsScreen(),
        // Add other routes here
      },
    );
  }
}
