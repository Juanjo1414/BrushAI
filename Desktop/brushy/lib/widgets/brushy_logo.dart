import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class BrushyLogo extends StatelessWidget {
  final double? size;
  const BrushyLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? ResponsiveHelper.getResponsiveSize(context, 64);

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7EE8FA), Color(0xFF80FFDB)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: ResponsiveHelper.getResponsiveSize(context, 10),
            offset: Offset(0, ResponsiveHelper.getResponsiveSize(context, 6)),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.medical_services,
          size: logoSize * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }
}
