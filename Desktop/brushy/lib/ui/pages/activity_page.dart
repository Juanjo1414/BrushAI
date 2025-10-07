// lib/ui/pages/activity_page.dart
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final a = activities[i];
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.event_note)),
              title: Text(a.$1),
              subtitle: Text(a.$2),
              trailing: FilledButton.tonal(
                onPressed: () {},
                child: const Text('abrir'),
              ),
            ),
          );
        },
      ),
    );
  }
}
