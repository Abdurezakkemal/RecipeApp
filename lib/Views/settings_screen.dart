import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Provider/settings_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipeapp/Views/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
        foregroundColor: settings.isDarkMode ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: settings.isDarkMode,
              onChanged: (value) {
                settings.toggleTheme();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Font Size',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: settings.fontSize,
              min: 12,
              max: 24,
              divisions: 6,
              label: settings.fontSize.toString(),
              onChanged: (value) {
                settings.setFontSize(value);
              },
            ),
            Text(
              'Sample Text',
              style: TextStyle(fontSize: settings.fontSize),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }
}
