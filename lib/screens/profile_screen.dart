import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _userName = 'QAMBAR ABBAS';
  static const _userEmail = 'qambarofficial313@gmail.com';
  static const _userBio = 'Tech enthusiast, developer, and constant learner.';
  static const _courseBranch = 'BCA';
  static const _rollNo = '2201163';
  static const _phone = '+91 85108 42558';

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              child: ClipOval(
                child: Image.asset(
                  'assets/qambar.png',
                  width: 120, // diameter = 2 * radius
                  height: 120,
                  fit: BoxFit.cover, // Ensures the image fills the circle
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              _userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _userBio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.email_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: const Text('Email'),
                    subtitle: Text(_userEmail),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.account_tree_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: const Text('Course/Branch'),
                    subtitle: Text(_courseBranch),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.list_alt,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: const Text('Roll No'),
                    subtitle: Text(_rollNo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: const Text('Phone'),
                    subtitle: Text(_phone),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.login,
                    (_) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
