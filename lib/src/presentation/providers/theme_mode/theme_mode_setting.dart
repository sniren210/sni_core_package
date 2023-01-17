part of sni_core;

abstract class ThemeModeSetting with ChangeNotifier {
  ThemeModeSetting();

  Future<void> darkMode();

  Future<void> lightMode();

  Future<void> system();

  ThemeMode get mode;

  Future<void> setMode(ThemeMode mode);
}

class ThemeModeSettingImpl extends ThemeModeSetting {
  final SharedPreferences preferences;

  ThemeModeSettingImpl({
    required this.preferences,
  });

  @override
  Future<void> darkMode() {
    return setMode(ThemeMode.dark);
  }

  @override
  Future<void> lightMode() {
    return setMode(ThemeMode.light);
  }

  @override
  Future<void> system() {
    return setMode(ThemeMode.system);
  }

  @override
  ThemeMode get mode {
    final value = preferences.getInt('theme_mode_setting');
    if (value == null) {
      return ThemeMode.system;
      // return Xetia.instance._defaultThemeMode ?? ThemeMode.system;
    }

    return ThemeMode.values[value];
  }

  @override
  Future<void> setMode(ThemeMode mode) async {
    await preferences.setInt('theme_mode_setting', mode.index);
    notifyListeners();
  }
}
