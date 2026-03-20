import 'package:flutter/material.dart';

import '../features/timer/timer_painters.dart';
import 'models.dart';

abstract class AuroraTheme {
  String get name;
  String get title;
  Color get bgColor;
  Color get accentColor;
  IconData get icon;

  String getModeLabel(TimerMode mode);

  CustomPainter getPainter(
    TimerMode mode, {
    required double progress,
    required double animation,
    required bool isRunning,
  });

  static AuroraTheme fromType(ThemeType type) {
    switch (type) {
      case ThemeType.cook:
        return CookTheme();
      case ThemeType.forest:
        return ForestTheme();
      case ThemeType.space:
        return SpaceTheme();
    }
  }
}

class CookTheme extends AuroraTheme {
  @override
  String get name => 'Flame';
  @override
  String get title => 'FLAME AURORA';
  @override
  Color get bgColor => const Color(0xFF0F0505);
  @override
  Color get accentColor => const Color(0xFFFF0033);
  @override
  IconData get icon => Icons.local_fire_department_rounded;

  @override
  String getModeLabel(TimerMode mode) =>
      mode == TimerMode.focus ? 'Incineration' : 'Cooling';

  @override
  CustomPainter getPainter(
    TimerMode mode, {
    required double progress,
    required double animation,
    required bool isRunning,
  }) {
    return mode == TimerMode.focus
        ? PotPainter(
            progress: progress,
            steamAnimation: animation,
            isRunning: isRunning,
            color: accentColor,
          )
        : CupPainter(
            progress: progress,
            teaAnimation: animation,
            isRunning: isRunning,
          );
  }
}

class ForestTheme extends AuroraTheme {
  @override
  String get name => 'Leaf';
  @override
  String get title => 'LEAF AURORA';
  @override
  Color get bgColor => const Color(0xFF05120A);
  @override
  Color get accentColor => const Color(0xFF00FF88);
  @override
  IconData get icon => Icons.spa_rounded;

  @override
  String getModeLabel(TimerMode mode) =>
      mode == TimerMode.focus ? 'Photosynthesis' : 'Transpiration';

  @override
  CustomPainter getPainter(
    TimerMode mode, {
    required double progress,
    required double animation,
    required bool isRunning,
  }) {
    return mode == TimerMode.focus
        ? TreePainter(
            progress: progress,
            animation: animation,
            isRunning: isRunning,
            color: accentColor,
          )
        : WateringCanPainter(
            progress: progress,
            animation: animation,
            isRunning: isRunning,
          );
  }
}

class SpaceTheme extends AuroraTheme {
  @override
  String get name => 'Void';
  @override
  String get title => 'VOID AURORA';
  @override
  Color get bgColor => const Color(0xFF050512);
  @override
  Color get accentColor => const Color(0xFF0099FF);
  @override
  IconData get icon => Icons.blur_on_rounded;

  @override
  String getModeLabel(TimerMode mode) =>
      mode == TimerMode.focus ? 'Propulsion' : 'Equilibrium';

  @override
  CustomPainter getPainter(
    TimerMode mode, {
    required double progress,
    required double animation,
    required bool isRunning,
  }) {
    return mode == TimerMode.focus
        ? RocketPainter(
            progress: progress,
            animation: animation,
            isRunning: isRunning,
            color: accentColor,
          )
        : AstronautPainter(
            progress: progress,
            animation: animation,
            isRunning: isRunning,
          );
  }
}
