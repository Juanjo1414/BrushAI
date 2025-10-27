import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = getScreenWidth(context);
    if (width < 360) {
      return baseSize * 0.85;
    }
    if (width < 600) {
      return baseSize;
    }
    if (width < 1200) {
      return baseSize * 1.1;
    }
    return baseSize * 1.2;
  }

  static double getResponsiveSize(BuildContext context, double baseSize) {
    final width = getScreenWidth(context);
    if (width < 360) {
      return baseSize * 0.8;
    }
    if (width < 600) {
      return baseSize;
    }
    if (width < 1200) {
      return baseSize * 1.1;
    }
    return baseSize * 1.2;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 360) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
    if (width < 1200) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 64, vertical: 32);
  }

  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 360) {
      return const EdgeInsets.all(8);
    }
    if (width < 600) {
      return const EdgeInsets.all(12);
    }
    if (width < 1200) {
      return const EdgeInsets.all(16);
    }
    return const EdgeInsets.all(24);
  }

  static double getContainerMaxWidth(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 600) {
      return width * 0.95;
    }
    if (width < 1200) {
      return 600;
    }
    return 800;
  }
}
