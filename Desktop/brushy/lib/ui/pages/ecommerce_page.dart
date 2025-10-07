// lib/ui/pages/ecommerce_page.dart
import 'package:flutter/material.dart';

class EcommercePage extends StatelessWidget {
  const EcommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BRUSHY AI'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // search
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Recomendación diaria card
          _RecommendationCard(),

          const SizedBox(height: 20),
          Text('pasos', style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 12),
          Row(
            children: const [
              _StepTile(title: 'cepillarse', icon: Icons.timer),
              SizedBox(width: 12),
              _StepTile(title: 'escanear', icon: Icons.camera_alt_outlined),
              SizedBox(width: 12),
              _StepTile(title: 'recomendación', icon: Icons.recommend_outlined),
            ],
          ),

          const SizedBox(height: 20),
          Text('historial fotográfico del usuario', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 120,
                  color: Colors.grey.shade300,
                  child: Center(child: Text('foto ${i + 1}')),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: 6,
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _TinyStat(label: '1 día'),
              _TinyStat(label: '30 días'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/mock/fruit.jpg'), // opcional, si no tienes la imagen, se verá blanco
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(.35), Colors.transparent],
          ),
        ),
        child: const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'RECOMENDACIÓN DIARIA',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const _StepTile({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  final String label;
  const _TinyStat({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Text(label),
    );
  }
}
