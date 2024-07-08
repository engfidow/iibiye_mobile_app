import 'package:flash_retail/providers/user_provider.dart';
import 'package:flash_retail/screens/Sigin_screen.dart';
import 'package:flash_retail/screens/settings_screen.dart';
import 'package:flash_retail/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userName = "Eng Sahal";
  final String userProfilePicUrl = "https://via.placeholder.com/150";

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                  'https://retailflash.up.railway.app/$imageUrl'),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

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
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    var kEndpoint = "https://retailflash.up.railway.app/";
                    String imageUrl =
                        userProvider.user?.image ?? 'default_image_url';

                    return GestureDetector(
                      onTap: () => _showProfilePhoto(context, imageUrl),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(
                            'https://retailflash.up.railway.app/$imageUrl'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Text(
                      userProvider.user?.name ?? 'Guest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
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
                _buildSettingItem(context, IconlyLight.setting, 'Settings', () {
                  // Implement language change action
                  _Settings(context);
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
          leading: Icon(icon, color: Colors.red),
          title: Text(title, style: TextStyle(color: Colors.black87)),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.red, size: 14.0),
          onTap: onTap,
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    // Handle profile tap
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UpdateProfile()));
  }

  void _Settings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ));
  }

  void _navigateToSupport(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navigate to Supports')));
  }

  void _logout(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).logout();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (e) => const SigIn(),
      ),
    );
  }
}
