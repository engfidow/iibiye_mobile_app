import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String userName = "Eng Sahal";
  final String userProfilePicUrl = "https://via.placeholder.com/150";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfilePicUrl),
                  radius: 40,
                ),
                const SizedBox(width: 20),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSettingItem(context, IconlyLight.profile, 'Profile', () {
                  // Implement profile action
                  _navigateToProfile(context);
                }),
                _buildSettingItem(context, Icons.palette, 'Change Theme', () {
                  // Implement theme change action
                  _changeTheme(context);
                }),
                _buildSettingItem(context, Icons.language, 'Change Language',
                    () {
                  // Implement language change action
                  _changeLanguage(context);
                }),
                _buildSettingItem(
                    context, IconlyLight.password, 'Change Password', () {
                  // Implement language change action
                  _changePassword(context);
                }),
                _buildSettingItem(context, IconlyLight.info_circle, 'Supports',
                    () {
                  // Implement supports action
                  _navigateToSupport(context);
                }),
                _buildSettingItem(context, IconlyLight.logout, 'Logout', () {
                  // Implement logout action
                  _logout(context);
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black54),
          title: Text(title, style: TextStyle(color: Colors.black87)),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.black54, size: 14.0),
          onTap: onTap,
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navigate to Profile')));
  }

  void _changeTheme(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Theme Changed')));
  }

  void _changeLanguage(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Language Changed')));
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('password Changed')));
  }

  void _navigateToSupport(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navigate to Supports')));
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Logged out')));
  }
}
