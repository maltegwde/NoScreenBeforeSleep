import 'dart:async';

class ScreenNapTimer {
  // singleton class based on https://stackoverflow.com/a/12649574
  static final ScreenNapTimer _singleton = ScreenNapTimer._internal();
  int _counterSeconds = 360; // add reference to MySettings.NoScreenTimeDuration
  Timer? _timer;

  ScreenNapTimer._internal();

  factory ScreenNapTimer() {
    return _singleton;
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_counterSeconds == 0) {
          timer.cancel();
        } else {
          _counterSeconds--;
        }
      },
    );
  }

  void cancelTimer() {
    _timer!.cancel();
  }

  bool isTimerRunning() {
    if (_timer == null) {
      return false;
    }
    return _timer!.isActive;
  }

  int getRemainingSeconds() {
    return _counterSeconds;
  }
}
