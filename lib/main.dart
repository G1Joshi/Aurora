import 'package:flutter/material.dart';

import 'core/models.dart';
import 'core/theme.dart';
import 'features/timer/timer_view.dart';

void main() {
  runApp(const AuroraApp());
}

class AuroraApp extends StatefulWidget {
  const AuroraApp({super.key});

  @override
  State<AuroraApp> createState() => _AuroraAppState();
}

class _AuroraAppState extends State<AuroraApp> {
  ThemeType _currentThemeType = ThemeType.cook;

  AuroraTheme get _theme => AuroraTheme.fromType(_currentThemeType);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _theme.bgColor,
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Outfit'),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Outfit',
        ),
        colorScheme: ColorScheme.dark(
          primary: _theme.accentColor,
          surface: const Color(0xFF0A0A0F),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 2,
          activeTrackColor: _theme.accentColor,
          inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          thumbColor: Colors.white,
          overlayColor: _theme.accentColor.withValues(alpha: 0.2),
          valueIndicatorColor: _theme.accentColor,
        ),
      ),
      home: AuroraHome(
        initialTheme: _currentThemeType,
        onThemeChanged: (t) => setState(() => _currentThemeType = t),
      ),
    );
  }
}
