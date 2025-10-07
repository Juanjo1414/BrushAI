// lib/ui/pages/dashboard_page.dart
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: const [
              Expanded(child: _KpiCard(title: 'mejora este mes', value: '50%')),
              SizedBox(width: 12),
              Expanded(child: _KpiCard(title: 'personas usando', value: '2405')),
            ],
          ),
          const SizedBox(height: 16),
          _BigCard(
            title: 'ESCANEAR',
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Preview de cámara / banner')),
            ),
          ),
          const SizedBox(height: 20),
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
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
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
      elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ]),
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
        const Text('amigos', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...friends.map((f) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(f),
              subtitle: const Text('racha de 3 días'),
            )),
      ],
    );
  }
}
