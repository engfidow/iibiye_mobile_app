import 'package:flash_retail/providers/transaction_provider.dart';

import 'package:flash_retail/screens/home_screen.dart';
import 'package:flash_retail/screens/payment_method_screen.dart';
import 'package:flash_retail/screens/profile_screen.dart';
import 'package:flash_retail/screens/scan_screen.dart';
import 'package:flash_retail/screens/transaction_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:iconly/iconly.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

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
    IconlyLight.profile,
  ];
  final _labelList = ['Home', 'Transaction', 'Payments', 'Profile'];
  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionScreen(),
    const PaymentMethods(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: Scaffold(
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
          shape: const CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? const Color(0xFFDC143C) : Colors.grey;
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
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
