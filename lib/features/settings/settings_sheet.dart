import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class AuroraSettingsSheet extends StatelessWidget {
  final ThemeType currentTheme;
  final int focusMin;
  final int breakMin;
  final bool autoStart;
  final bool isRunning;
  final AuroraTheme theme;
  final ValueChanged<ThemeType> onThemeChanged;
  final Function(int, int) onDurationsChanged;
  final ValueChanged<bool> onAutoStartChanged;

  const AuroraSettingsSheet({
    super.key,
    required this.currentTheme,
    required this.focusMin,
    required this.breakMin,
    required this.autoStart,
    required this.isRunning,
    required this.theme,
    required this.onThemeChanged,
    required this.onDurationsChanged,
    required this.onAutoStartChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF050508),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(
            color: theme.accentColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, theme.accentColor],
                ).createShader(bounds),
                child: const Text(
                  'Aurora Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.close_fullscreen_rounded,
                  color: Colors.white24,
                  size: 16,
                ),
              ),
            ],
          ),
          if (isRunning) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded, color: theme.accentColor, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'FLOW ACTIVE - CONFIG LOCKED',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: theme.accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text('VIBE', style: AuroraConstants.sectionHeaderStyle),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ThemeOpt(
                type: ThemeType.cook,
                name: CookTheme().name,
                color: CookTheme().accentColor,
                isSel: currentTheme == ThemeType.cook,
                isLocked: isRunning,
                onSel: () => onThemeChanged(ThemeType.cook),
              ),
              _ThemeOpt(
                type: ThemeType.forest,
                name: ForestTheme().name,
                color: ForestTheme().accentColor,
                isSel: currentTheme == ThemeType.forest,
                isLocked: isRunning,
                onSel: () => onThemeChanged(ThemeType.forest),
              ),
              _ThemeOpt(
                type: ThemeType.space,
                name: SpaceTheme().name,
                color: SpaceTheme().accentColor,
                isSel: currentTheme == ThemeType.space,
                isLocked: isRunning,
                onSel: () => onThemeChanged(ThemeType.space),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('ARCHITECTURE', style: AuroraConstants.sectionHeaderStyle),
          const SizedBox(height: 8),
          _GlowSlider(
            label: 'FLOW',
            val: focusMin,
            min: 5,
            max: 90,
            color: theme.accentColor,
            isLocked: isRunning,
            onChg: (v) => onDurationsChanged(v, breakMin),
          ),
          _GlowSlider(
            label: 'REST',
            val: breakMin,
            min: 1,
            max: 30,
            color: theme.accentColor,
            isLocked: isRunning,
            onChg: (v) => onDurationsChanged(focusMin, v),
          ),
          const SizedBox(height: 24),
          const Text('PREFERENCES', style: AuroraConstants.sectionHeaderStyle),
          const SizedBox(height: 12),
          _GlowToggle(
            label: 'AUTO FLOW',
            val: autoStart,
            color: theme.accentColor,
            isLocked: isRunning,
            onChg: onAutoStartChanged,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _GlowToggle extends StatelessWidget {
  final String label;
  final bool val;
  final Color color;
  final bool isLocked;
  final ValueChanged<bool> onChg;
  const _GlowToggle({
    required this.label,
    required this.val,
    required this.color,
    required this.isLocked,
    required this.onChg,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : () => onChg(!val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 36,
              height: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: val ? color : Colors.white12,
                boxShadow: val
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: val ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOpt extends StatelessWidget {
  final ThemeType type;
  final String name;
  final Color color;
  final bool isSel;
  final bool isLocked;
  final VoidCallback onSel;
  const _ThemeOpt({
    required this.type,
    required this.name,
    required this.color,
    required this.isSel,
    required this.isLocked,
    required this.onSel,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onSel,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSel ? color : Colors.white.withValues(alpha: 0.05),
              border: isSel ? Border.all(color: Colors.white, width: 2) : null,
              boxShadow: isSel
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.flare_rounded,
              color: isSel ? Colors.white : Colors.white10,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: isSel ? FontWeight.w900 : FontWeight.w500,
              color: isSel ? Colors.white : Colors.white24,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowSlider extends StatelessWidget {
  final String label;
  final int val;
  final int min;
  final int max;
  final Color color;
  final bool isLocked;
  final ValueChanged<int> onChg;
  const _GlowSlider({
    required this.label,
    required this.val,
    required this.min,
    required this.max,
    required this.color,
    required this.isLocked,
    required this.onChg,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AuroraConstants.secondaryLabelStyle),
            Text(
              '${val}m',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isLocked ? Colors.white24 : color,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            trackShape: const _GlowSliderTrackShape(),
          ),
          child: Slider(
            value: val.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: isLocked ? null : (v) => onChg(v.round()),
          ),
        ),
      ],
    );
  }
}

class _GlowSliderTrackShape extends RoundedRectSliderTrackShape {
  const _GlowSliderTrackShape();
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );
    final paint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 16);
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final leftTrackSegment = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(leftTrackSegment, const Radius.circular(2)),
      paint,
    );
  }
}
