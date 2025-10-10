// lib/ui/pages/ecommerce_page.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class EcommercePage extends StatelessWidget {
  const EcommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Center(
          child: Container(
            width: ResponsiveHelper.getContainerMaxWidth(context),
            child: ListView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      hintStyle: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          16,
                        ),
                        color: Colors.grey[500],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: ResponsiveHelper.getResponsiveSize(context, 20),
                        color: Colors.grey[500],
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getResponsiveSize(
                          context,
                          16,
                        ),
                        vertical: ResponsiveHelper.getResponsiveSize(
                          context,
                          12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 20),
                ),

                // Recomendación diaria card
                _RecommendationCard(),

                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 24),
                ),
                Text(
                  'pasos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _StepTile(title: 'cepillarse', icon: Icons.brush),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSize(context, 12),
                    ),
                    Expanded(
                      child: _StepTile(
                        title: 'escanear',
                        icon: Icons.camera_alt_outlined,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSize(context, 12),
                    ),
                    Expanded(
                      child: _StepTile(
                        title: 'recomendación',
                        icon: Icons.recommend_outlined,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 24),
                ),
                Text(
                  'historial fotográfico del usuario',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 16),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 84),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: ResponsiveHelper.getResponsiveSize(context, 120),
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Text(
                            'foto ${i + 1}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => SizedBox(
                      width: ResponsiveHelper.getResponsiveSize(context, 10),
                    ),
                    itemCount: 6,
                  ),
                ),

                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TinyStat(label: '1 día'),
                    _TinyStat(label: '30 días'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getResponsiveSize(context, 160),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1976D2).withOpacity(0.8),
            const Color(0xFF42A5F5).withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'RECOMENDACIÓN\nDIARIA',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
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
    return Container(
      height: ResponsiveHelper.getResponsiveSize(context, 76),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: ResponsiveHelper.getResponsiveSize(context, 24),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 4)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveSize(context, 12),
        vertical: ResponsiveHelper.getResponsiveSize(context, 6),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: ResponsiveHelper.getResponsiveSize(context, 6),
            offset: Offset(0, ResponsiveHelper.getResponsiveSize(context, 3)),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
