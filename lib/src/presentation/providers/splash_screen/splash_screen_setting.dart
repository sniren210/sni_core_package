part of sni_core;

enum SplashscreenState {
  shown,
  settle,
  closing,
  closed,
}

@Injectable()
class SplashscreenSetting with ChangeNotifier {
  SplashscreenState _value = SplashscreenState.shown;
  SplashscreenSetting() {
    _ready();
  }

  final List<Future> _futures = [];

  void wait(Future future) {
    _futures.add(future);
  }

  final Completer _settleCompleter = Completer();
  void _settle() {
    if (!_settleCompleter.isCompleted) {
      _settleCompleter.complete();
    }
  }

  final Completer _closeCompleter = Completer();
  void _close() {
    if (!_closeCompleter.isCompleted) {
      _closeCompleter.complete();
    }
  }

  /// call this on home screen ready
  Future<void> _ready() async {
    await Future.delayed(const Duration(seconds: 1));
    await Future.wait([
      _settleCompleter.future,
      ..._futures,
    ]);

    _value = SplashscreenState.closing;
    notifyListeners();

    await _closeCompleter.future;
    _value = SplashscreenState.closed;
    notifyListeners();
  }

  SplashscreenState get value => _value;
}

mixin SplashscreenReadyMixin<T extends StatefulWidget> on State<T> {
  Future<void> initializeInSplash();

  @override
  void initState() {
    super.initState();
    final initialize = initializeInSplash();
    context.read<SplashscreenSetting>().wait(initialize);
  }
}

mixin SplashscreenMixin<T extends StatefulWidget> on State<T> {
  /// execute after animation idle enter
  void idle() {
    context.read<SplashscreenSetting>()._settle();
  }

  /// execute after closing animation finished
  void close() {
    context.read<SplashscreenSetting>()._close();
  }

  void onStateChanged(SplashscreenState state);
  void _listener() {
    if (mounted) {
      onStateChanged(_splash.value);
    }
  }

  @override
  void dispose() {
    _splash.removeListener(_listener);
    super.dispose();
  }

  late SplashscreenSetting _splash;
  Duration? get autoSettleDuration => null;

  @override
  void initState() {
    super.initState();

    _splash = context.read<SplashscreenSetting>();
    _splash.addListener(_listener);

    Future.microtask(() async {
      final Duration? dur = autoSettleDuration;
      if (dur != null) {
        await Future.delayed(dur);
        idle();
      }
    });
  }
}
