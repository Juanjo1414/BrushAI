// lib/ui/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 16),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: _KpiCard(title: 'mejora este mes', value: '50%'),
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 12)),
              Expanded(
                child: _KpiCard(title: 'personas usando', value: '2405'),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          _BigCard(
            title: 'ESCANEAR',
            child: Container(
              height: ResponsiveHelper.getResponsiveSize(context, 140),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Preview de cámara / banner',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      14,
                    ),
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 20)),
          const _FriendsList(),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black54,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _BigCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
            child,
          ],
        ),
      ),
    );
  }
}

class _FriendsList extends StatelessWidget {
  const _FriendsList();

  @override
  Widget build(BuildContext context) {
    final friends = ['Elynn Lee', 'Oscar dum'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'amigos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
        ...friends.map(
          (f) => ListTile(
            leading: CircleAvatar(
              radius: ResponsiveHelper.getResponsiveSize(context, 20),
              child: Icon(
                Icons.person,
                size: ResponsiveHelper.getResponsiveSize(context, 20),
              ),
            ),
            title: Text(
              f,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'racha de 3 días',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
