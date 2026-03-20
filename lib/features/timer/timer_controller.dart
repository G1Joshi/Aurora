import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models.dart';

class TimerController extends ChangeNotifier {
  TimerController({
    required int focusMin,
    required int breakMin,
    required bool autoStart,
  }) : _focusMin = focusMin,
       _breakMin = breakMin,
       _autoStart = autoStart {
    _remainingSeconds = _focusMin * 60;
  }

  int _focusMin;
  int _breakMin;
  bool _autoStart;

  int get focusMin => _focusMin;
  int get breakMin => _breakMin;
  bool get autoStart => _autoStart;

  TimerMode _mode = TimerMode.focus;
  TimerMode get mode => _mode;

  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Timer? _timer;

  int get totalSeconds =>
      (_mode == TimerMode.focus ? _focusMin : _breakMin) * 60;
  double get progress => 1.0 - (_remainingSeconds / totalSeconds);

  void updateSettings({int? focusMin, int? breakMin, bool? autoStart}) {
    if (focusMin != null) _focusMin = focusMin;
    if (breakMin != null) _breakMin = breakMin;
    if (autoStart != null) _autoStart = autoStart;

    if (!_isRunning) {
      _remainingSeconds = totalSeconds;
    }
    notifyListeners();
  }

  void switchMode(TimerMode newMode) {
    if (_isRunning) return;
    _mode = newMode;
    _remainingSeconds = totalSeconds;
    notifyListeners();
  }

  void toggleTimer() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          _onComplete();
        }
      });
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  void _onComplete() {
    _mode = _mode == TimerMode.focus ? TimerMode.breakTime : TimerMode.focus;
    _remainingSeconds = totalSeconds;
    notifyListeners();

    if (_autoStart) {
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!_isRunning) toggleTimer();
      });
    }
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = totalSeconds;
    notifyListeners();
  }

  void fastForward() {
    if (_isRunning) return;
    _onComplete();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
