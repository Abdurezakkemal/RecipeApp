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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
        foregroundColor: settings.isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Text(
              'Preferences',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Dark Mode Switch
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  "Dark Mode",
                  style: theme.textTheme.bodyMedium,
                ),
                value: settings.isDarkMode,
                onChanged: (value) {
                  settings.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Font Size Slider
            Text(
              'Font Size',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: settings.fontSize,
              ),
            ),
            const Divider(),

            // Account Section
            const SizedBox(height: 20),
            Text(
              'Account',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await _logout(context);
                },
              ),
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
