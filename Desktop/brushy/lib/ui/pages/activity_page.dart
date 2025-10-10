// lib/ui/pages/activity_page.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      ('resultado del escaneo', '3s escaneando...', 'general'),
      ('recomendaciones', 'se recomienda cepillar más...', 'general'),
      ('recap semanal del cepillado', 'se ha visto un 30% menos...', 'general'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 16),
        ),
        itemCount: activities.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 10)),
        itemBuilder: (_, i) {
          final a = activities[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(
                ResponsiveHelper.getResponsiveSize(context, 12),
              ),
              leading: CircleAvatar(
                radius: ResponsiveHelper.getResponsiveSize(context, 20),
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  Icons.event_note,
                  size: ResponsiveHelper.getResponsiveSize(context, 20),
                  color: Colors.blue,
                ),
              ),
              title: Text(
                a.$1,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveHelper.getResponsiveSize(context, 4),
                ),
                child: Text(
                  a.$2,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    color: Colors.black87,
                  ),
                ),
              ),
              trailing: FilledButton.tonal(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsiveSize(context, 12),
                    vertical: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                ),
                child: Text(
                  'abrir',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
