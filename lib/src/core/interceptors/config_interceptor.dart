part of sni_core;

class _ConfigInterceptor extends InterceptorsWrapper {
  final ThemeModeSetting themeModeSetting;
  final LocaleSetting localeSetting;
  final VibrationSetting vibrationSetting;
  final SoundSetting soundSetting;
  final MotionSetting motionSetting;

  _ConfigInterceptor({
    required this.themeModeSetting,
    required this.localeSetting,
    required this.vibrationSetting,
    required this.soundSetting,
    required this.motionSetting,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.setHeader(
      'app_dark_theme',
      themeModeSetting.mode == ThemeMode.dark,
    );
    options.setHeader('locale', localeSetting.value);
    options.setHeader('vibration', vibrationSetting.status);
    options.setHeader('sound', soundSetting.status);
    options.setHeader('motion', motionSetting.status);

    handler.next(options);
  }
}
