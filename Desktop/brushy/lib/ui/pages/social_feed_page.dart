// lib/ui/pages/social_feed_page.dart
import 'package:flutter/material.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      ('sistema FACTURACION N01', 'Se ha realizado con éxito el pago de la suscripción', 'Hace 2 horas'),
      ('sistema FACTURACION N02', 'Se ha detectado un error en el método de pago, por favor verifique...', 'Hace 1 hora'),
      ('sistema FACTURACION N03', 'Se ha realizado con éxito su compra', 'Hace 20 minutos'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social feed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final p = posts[i];
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.auto_awesome),
              ),
              title: Text(p.$1),
              subtitle: Text(p.$2),
              trailing: Text(p.$3, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }
}
