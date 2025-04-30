import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          _notificationCard(
            context,
            title: 'Dr. Kaveri Umeesh Kadam',
            subtitle: 'Urgent',
            message: '3 students were absent today',
            icon: Icons.person,
          ),
          _notificationCard(
            context,
            title: 'HOD',
            subtitle: 'Meeting',
            message: 'Meeting scheduled for 3 p.m.',
            icon: Icons.person_2,
          ),
          // Add more notifications here
        ],
      ),
    );
  }

  Widget _notificationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String message,
    required IconData icon,
  }) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        isThreeLine: true,
        onTap: () => _showNotificationDialog(context, message),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Notification'),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
