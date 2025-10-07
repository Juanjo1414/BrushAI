// lib/ui/pages/checkout_page.dart
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Plan('suscripción', 'Marca\nno anuncios\nDescripción: dispon de la aplicación sin ...', 10.99),
      _Plan('suscripción', 'Marca\nacceso a el escaner de manera il...', 8.99),
    ];

    final subtotal = items.fold<double>(0, (s, e) => s + e.price);
    final impuestos = 2.00;
    final total = subtotal + impuestos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de pago'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderTile(title: 'PAGO', trailing: 'Visa *1234'),
          const SizedBox(height: 6),
          _HeaderTile(title: 'PROMOCIONES', trailing: 'Aplicar código de promoción'),
          const SizedBox(height: 12),
          ...items.map((p) => _PlanTile(plan: p)).toList(),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Subtotal (${items.length})', value: subtotal),
          _SummaryRow(label: 'Impuestos', value: impuestos),
          const Divider(height: 20),
          _SummaryRow(label: 'Total', value: total, bold: true),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido realizado (mock).')),
              ),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Hacer pedido'),
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderTile extends StatelessWidget {
  final String title;
  final String trailing;
  const _HeaderTile({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(trailing, style: const TextStyle(color: Colors.black87)),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right)
      ]),
    );
  }
}

class _Plan {
  final String type;
  final String desc;
  final double price;
  _Plan(this.type, this.desc, this.price);
}

class _PlanTile extends StatelessWidget {
  final _Plan plan;
  const _PlanTile({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            height: 44, width: 44,
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.workspace_premium, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('${plan.type}\n${plan.desc}', maxLines: 3, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Text('\$${plan.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text('\$${value.toStringAsFixed(2)}', style: style)],
      ),
    );
  }
}
