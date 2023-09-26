import 'package:denguecare_firebase/views/users/user_dengueheatmap.dart';
import 'package:denguecare_firebase/views/users/user_report_page.dart';
import 'package:denguecare_firebase/views/users/user_settings_page.dart';
import 'package:denguecare_firebase/views/widgets/post_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: <Widget>[
          PopupMenuButton<int>(
            padding: EdgeInsets.zero,
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: const Icon(
                    Icons.info,
                    color: Colors.black,
                    size: 26,
                  ),
                  title: const Text('About'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
      body: const PostsList(),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }
}

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  int currentIndex = 0;
  final screens = [
    const UserHomePage(),
    const UserDengueHeatMapPage(),
    const UserReportPage(),
    const UserSettingsPage(),
  ];
  Widget _getCurrentScreen() {
    switch (currentIndex) {
      case 0:
        return const UserHomePage();
      case 1:
        return const UserDengueHeatMapPage();
      case 2:
        return const UserReportPage();
      case 3:
        return const UserSettingsPage();
      default:
        return const UserHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: _navBarItemsUser,
      ),
    );
  }
}

const _navBarItemsUser = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.map_outlined),
    selectedIcon: Icon(Icons.map_rounded),
    label: 'Map',
  ),
  NavigationDestination(
    icon: Icon(Icons.report_outlined),
    selectedIcon: Icon(Icons.report_rounded),
    label: 'Report',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings_rounded),
    label: 'Settings',
  ),
];
