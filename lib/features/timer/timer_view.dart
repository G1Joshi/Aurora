import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../settings/settings_sheet.dart';
import 'timer_controller.dart';
import 'timer_painters.dart';

class AuroraHome extends StatefulWidget {
  final ThemeType initialTheme;
  final ValueChanged<ThemeType> onThemeChanged;
  const AuroraHome({
    super.key,
    required this.initialTheme,
    required this.onThemeChanged,
  });

  @override
  State<AuroraHome> createState() => _AuroraHomeState();
}

class _AuroraHomeState extends State<AuroraHome> with TickerProviderStateMixin {
  late ThemeType _themeType;
  late TimerController _controller;
  TimerMode? _lastMode;

  AuroraTheme get _theme => AuroraTheme.fromType(_themeType);

  late PageController _modeController;
  late AnimationController _visualController;

  @override
  void initState() {
    super.initState();
    _themeType = widget.initialTheme;
    _controller = TimerController(focusMin: 25, breakMin: 5, autoStart: true);
    _lastMode = _controller.mode;
    _controller.addListener(_onControllerUpdate);

    _modeController = PageController(initialPage: 0);
    _visualController = AnimationController(
      vsync: this,
      duration: AuroraConstants.visualLoopDuration,
    )..repeat();
  }

  void _onControllerUpdate() {
    if (_lastMode != _controller.mode) {
      _lastMode = _controller.mode;
      _modeController.animateToPage(
        _controller.mode == TimerMode.focus ? 0 : 1,
        duration: AuroraConstants.timerTransitionDuration,
        curve: Curves.easeInOutCubic,
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _modeController.dispose();
    _visualController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    if (_controller.isRunning) return;
    _controller.switchMode(page == 0 ? TimerMode.focus : TimerMode.breakTime);
  }

  void _updateTheme(ThemeType t) {
    setState(() => _themeType = t);
    widget.onThemeChanged(t);
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => AuroraSettingsSheet(
          currentTheme: _themeType,
          focusMin: _controller.focusMin,
          breakMin: _controller.breakMin,
          autoStart: _controller.autoStart,
          isRunning: _controller.isRunning,
          theme: _theme,
          onThemeChanged: _updateTheme,
          onDurationsChanged: (f, b) =>
              _controller.updateSettings(focusMin: f, breakMin: b),
          onAutoStartChanged: (v) => _controller.updateSettings(autoStart: v),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: AuroraConstants.themeTransitionDuration,
        width: AuroraConstants.appWidth,
        height: AuroraConstants.appHeight,
        decoration: BoxDecoration(color: _theme.bgColor),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _visualController,
                builder: (context, child) => CustomPaint(
                  painter: BackgroundPainter(
                    pulse: _visualController.value,
                    themeColor: _theme.accentColor,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: PageView.builder(
                      controller: _modeController,
                      onPageChanged: _onPageChanged,
                      physics: _controller.isRunning
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (_, index) => _buildCarouselPage(
                        index == 0 ? TimerMode.focus : TimerMode.breakTime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTimerDisplay(),
                  const SizedBox(height: 6),
                  _buildControls(),
                  const SizedBox(height: 16),
                  _buildIndicatorDots(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/logo/icon.png', width: 24, height: 24),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, _theme.accentColor],
                ).createShader(bounds),
                child: Text(_theme.title, style: AuroraConstants.labelStyle),
              ),
            ],
          ),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(
              Icons.tune_rounded,
              color: Colors.white24,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselPage(TimerMode mode) {
    final isCurrent = mode == _controller.mode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: isCurrent ? _controller.progress : 0,
                ),
                duration: AuroraConstants.timerTransitionDuration,
                curve: Curves.linear,
                builder: (context, value, child) => CustomPaint(
                  size: const Size(250, 250),
                  painter: ProgressRingPainter(
                    progress: value,
                    color: _theme.accentColor,
                    pulse: _visualController.value,
                  ),
                ),
              ),
              RepaintBoundary(
                child: CustomPaint(
                  size: const Size(150, 150),
                  painter: _theme.getPainter(
                    mode,
                    progress: _controller.progress,
                    animation: _visualController.value,
                    isRunning: _controller.isRunning,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        AnimatedOpacity(
          opacity: isCurrent ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 800),
          child: Text(
            _theme.getModeLabel(mode).toUpperCase(),
            style: AuroraConstants.labelStyle.copyWith(
              color: _theme.accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, _theme.accentColor.withValues(alpha: 0.5)],
      ).createShader(bounds),
      child: Text(
        '${(_controller.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_controller.remainingSeconds % 60).toString().padLeft(2, '0')}',
        style: AuroraConstants.timerStyle,
      ),
    );
  }

  Widget _buildControls() {
    final accent = _theme.accentColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _controller.reset,
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white12,
            size: 20,
          ),
        ),
        const SizedBox(width: 40),
        GestureDetector(
          onTap: _controller.toggleTimer,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [accent, accent.withValues(alpha: 0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _controller.isRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: _controller.isRunning
              ? null
              : () {
                  _controller.fastForward();
                  _modeController.animateToPage(
                    _controller.mode == TimerMode.focus ? 0 : 1,
                    duration: AuroraConstants.timerTransitionDuration,
                    curve: Curves.easeInOutCubic,
                  );
                },
          icon: Icon(
            Icons.fast_forward_rounded,
            color: _controller.isRunning
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white12,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final active = index == (_controller.mode == TimerMode.focus ? 0 : 1);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: active ? 24 : 8,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: active
                ? _theme.accentColor
                : Colors.white.withValues(alpha: 0.05),
          ),
        );
      }),
    );
  }
}
