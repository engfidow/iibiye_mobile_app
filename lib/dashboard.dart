import 'package:flash_retail/screens/transaction_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// Import your screen classes here
import 'package:flash_retail/screens/home_screen.dart';
import 'package:flash_retail/screens/payment_screen.dart';
import 'package:flash_retail/screens/scan_screen.dart';
import 'package:flash_retail/screens/settings_screen.dart';
import 'package:iconly/iconly.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final _iconList = <IconData>[
    IconlyLight.home,
    IconlyLight.swap,
    CupertinoIcons.money_dollar,
    IconlyLight.setting,
  ];
  final _labelList = ['Home', 'Transaction', 'Payments', 'Settings'];
  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionScreen(),
    const PaymentsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFDC143C),
        elevation: 3,
        child: Icon(
          IconlyLight.camera,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanScreen()),
          );
        },
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Color(0xFFDC143C) : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_iconList[index], color: color, size: 24),
              Text(
                _labelList[index],
                style: TextStyle(color: color),
              )
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _selectedIndex,
        splashColor: Colors.purple[300],
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,

        // leftCornerRadius: 32,
        // rightCornerRadius: 32,

        onTap: (index) => setState(() => _selectedIndex = index),
        // Other parameters
      ),
    );
  }
}
