import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/routes.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  static const _tabs = <Widget>[
    HomeContent(),
    ProfileScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  static const _navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.bell),
      label: 'Notifications',
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.add), label: 'Students'),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('AttendanceLab')),
      body: IndexedStack(
        index: _selectedIndex,
        children:
            _tabs.map((tab) {
              // Use a nested Navigator only if you need per-tab navigation
              return Navigator(
                onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => tab),
              );
            }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: (idx) => setState(() => _selectedIndex = idx),
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.attendance);
                },
                child: const Icon(Icons.edit),
              )
              : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome,',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'USER !',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Performance chart placeholder',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(Routes.attendance),
            child: const Text('Mark Attendance'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed:
                () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(Routes.history),
            child: const Text('View Attendance History'),
          ),
        ],
      ),
    );
  }
}
