part of sni_core;

List<SingleChildWidget> _getConfigurationRepositories() => [
      ChangeNotifierProvider<ThemeModeSetting>.value(
        value: GetIt.I(),
      ),
      ChangeNotifierProvider<LocaleSetting>.value(
        value: GetIt.I(),
      ),
      ChangeNotifierProvider<SoundSetting>.value(
        value: GetIt.I(),
      ),
      ChangeNotifierProvider<MotionSetting>.value(
        value: GetIt.I(),
      ),
      ChangeNotifierProvider<VibrationSetting>.value(
        value: GetIt.I(),
      ),
      ChangeNotifierProvider<SplashscreenSetting>(
        create: (context) => GetIt.I(),
      ),
      // TODO: network service
      // ChangeNotifierProvider<NetworkService>(
      //   create: (context) => GetIt.I(),
      // ),
    ];
