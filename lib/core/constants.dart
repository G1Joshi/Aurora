import 'package:flutter/material.dart';

class AuroraConstants {
  static const double appWidth = 400.0;
  static const double appHeight = 500.0;
  static const double headerHeight = 48.0;
  static const double bottomPadding = 12.0;

  static const Duration themeTransitionDuration = Duration(milliseconds: 1000);
  static const Duration timerTransitionDuration = Duration(milliseconds: 1000);
  static const Duration visualLoopDuration = Duration(seconds: 4);

  static const TextStyle labelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
    color: Colors.white,
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w900,
    color: Colors.white24,
    letterSpacing: 2,
  );

  static const TextStyle secondaryLabelStyle = TextStyle(
    color: Colors.white38,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle timerStyle = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w100,
    color: Colors.white,
    letterSpacing: -2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
