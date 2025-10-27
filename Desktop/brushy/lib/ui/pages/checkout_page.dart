// lib/ui/pages/checkout_page.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Plan(
        'suscripción',
        'Marca\nno anuncios\nDescripción: dispon de la aplicación sin ...',
        10.99,
      ),
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
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSize(context, 16),
        ),
        children: [
          _HeaderTile(title: 'PAGO', trailing: 'Visa *1234'),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 6)),
          _HeaderTile(
            title: 'PROMOCIONES',
            trailing: 'Aplicar código de promoción',
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 12)),
          ...items.map((p) => _PlanTile(plan: p)),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 12)),
          _SummaryRow(label: 'Subtotal (${items.length})', value: subtotal),
          _SummaryRow(label: 'Impuestos', value: impuestos),
          Divider(height: ResponsiveHelper.getResponsiveSize(context, 20)),
          _SummaryRow(label: 'Total', value: total, bold: true),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 20)),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSize(context, 48),
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido realizado (mock).')),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Hacer pedido',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: TextStyle(
              color: Colors.black87,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 6)),
          Icon(
            Icons.chevron_right,
            size: ResponsiveHelper.getResponsiveSize(context, 20),
          ),
        ],
      ),
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
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveSize(context, 12),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSize(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: ResponsiveHelper.getResponsiveSize(context, 44),
            width: ResponsiveHelper.getResponsiveSize(context, 44),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.workspace_premium,
              color: Colors.blue,
              size: ResponsiveHelper.getResponsiveSize(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 12)),
          Expanded(
            child: Text(
              '${plan.type}\n${plan.desc}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                height: 1.3,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 8)),
          Text(
            '\$${plan.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
          )
        : TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
          );
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsiveSize(context, 6),
        horizontal: ResponsiveHelper.getResponsiveSize(context, 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
