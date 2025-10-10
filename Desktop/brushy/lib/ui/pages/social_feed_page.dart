// lib/ui/pages/social_feed_page.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      (
        'sistema FACTURACION N01',
        'Se ha realizado con éxito el pago de la suscripción',
        'Hace 2 horas',
      ),
      (
        'sistema FACTURACION N02',
        'Se ha detectado un error en el método de pago, por favor verifique...',
        'Hace 1 hora',
      ),
      (
        'sistema FACTURACION N03',
        'Se ha realizado con éxito su compra',
        'Hace 20 minutos',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social feed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 16),
        ),
        itemCount: posts.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 10)),
        itemBuilder: (_, i) {
          final p = posts[i];
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
                backgroundColor: Colors.blue.shade50,
                radius: ResponsiveHelper.getResponsiveSize(context, 20),
                child: Icon(
                  Icons.auto_awesome,
                  size: ResponsiveHelper.getResponsiveSize(context, 20),
                  color: Colors.blue,
                ),
              ),
              title: Text(
                p.$1,
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
                  p.$2,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    color: Colors.black87,
                  ),
                ),
              ),
              trailing: Text(
                p.$3,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
