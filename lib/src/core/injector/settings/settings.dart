part of sni_core;

Future<void> _initializeSettings({
  String? defaultLanguageCode,
}) async {
  GetIt.I.registerLazySingleton<LocaleSetting>(
    () => LocaleSettingImpl(
      defaultValue: defaultLanguageCode ?? 'en',
      preferences: GetIt.I(),
      supportedLocales:
          Sni.instance.supportedLocales.map((e) => e.languageCode).toList(),
    ),
  );

  GetIt.I.registerLazySingleton<ThemeModeSetting>(
    () => ThemeModeSettingImpl(
      preferences: GetIt.I(),
    ),
  );

  GetIt.I.registerLazySingleton<VibrationSetting>(
    () => VibrationSettingImpl(
      preferences: GetIt.I(),
    ),
  );
  GetIt.I.registerLazySingleton<SoundSetting>(
    () => SoundSettingImpl(
      preferences: GetIt.I(),
    ),
  );
  GetIt.I.registerLazySingleton<MotionSetting>(
    () => MotionSettingImpl(
      preferences: GetIt.I(),
    ),
  );
}
