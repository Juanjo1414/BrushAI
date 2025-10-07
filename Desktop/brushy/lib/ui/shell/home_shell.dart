import 'package:flutter/material.dart';
import '../pages/ecommerce_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/social_feed_page.dart';
import '../pages/activity_page.dart';
import '../pages/checkout_page.dart';

class HomeShell extends StatefulWidget {
  final String email;
  const HomeShell({super.key, required this.email});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    EcommercePage(),
    DashboardPage(),
    SocialFeedPage(),
    ActivityPage(),
    CheckoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.local_activity_outlined), selectedIcon: Icon(Icons.local_activity), label: 'Actividad'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Checkout'),
        ],
      ),
    );
  }
}
