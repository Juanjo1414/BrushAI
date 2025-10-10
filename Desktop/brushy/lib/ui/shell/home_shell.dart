import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../pages/ecommerce_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/social_feed_page.dart';
import '../pages/activity_page.dart';
import '../pages/checkout_page.dart';

/// HomeShell con todas las páginas originales responsive
class HomeShell extends StatefulWidget {
  final String email;
  final VoidCallback? onLogout;

  const HomeShell({super.key, required this.email, this.onLogout});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const EcommercePage(),
    const DashboardPage(),
    const SocialFeedPage(),
    const ActivityPage(),
    const CheckoutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                if (widget.onLogout != null) {
                  widget.onLogout!();
                }
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BRUSHY AI',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: ResponsiveHelper.getResponsiveSize(context, 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar del usuario
                CircleAvatar(
                  radius: ResponsiveHelper.getResponsiveSize(context, 16),
                  backgroundColor: const Color(0xFF1976D2),
                  child: Icon(
                    Icons.person,
                    size: ResponsiveHelper.getResponsiveSize(context, 18),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 8)),
                // Botón de logout
                IconButton(
                  onPressed: _logout,
                  icon: Icon(
                    Icons.logout,
                    size: ResponsiveHelper.getResponsiveSize(context, 24),
                    color: Colors.grey[600],
                  ),
                  tooltip: 'Cerrar sesión',
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        selectedFontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
        unselectedFontSize: ResponsiveHelper.getResponsiveFontSize(context, 10),
        iconSize: ResponsiveHelper.getResponsiveSize(context, 24),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
        ],
      ),
    );
  }
}
