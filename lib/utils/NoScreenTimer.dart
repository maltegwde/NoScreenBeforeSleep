import 'dart:async';

class NoScreenTimer {
  // singleton class based on https://stackoverflow.com/a/12649574
  static final NoScreenTimer _singleton = NoScreenTimer._internal();
  int _counter = 360; // add reference to MySettings.NoScreenTimeDuration
  late Timer _timer;

  NoScreenTimer._internal();

  factory NoScreenTimer() {
    return _singleton;
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_counter == 0) {
          timer.cancel();
        } else {
          _counter--;
        }
      },
    );
  }

  void cancelTimer() {
    _timer.cancel();
  }

  bool isTimerRunning() {
    return _timer.isActive;
  }
}
