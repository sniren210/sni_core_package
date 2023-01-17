part of sni_core;

abstract class VibrationSetting with ChangeNotifier {
  VibrationSetting();

  Future<void> active();

  Future<void> disable();

  bool get status;
  Future<void> setStatus(bool status);
}

class VibrationSettingImpl extends VibrationSetting {
  final SharedPreferences preferences;

  VibrationSettingImpl({required this.preferences});

  @override
  Future<void> active() {
    return setStatus(true);
  }

  @override
  Future<void> disable() {
    return setStatus(false);
  }

  @override
  bool get status {
    return preferences.getBool('vibration_setting') ?? true;
  }

  @override
  Future<void> setStatus(bool? status) async {
    if (status == null) {
      await preferences.remove('vibration_setting');
    } else {
      await preferences.setBool('vibration_setting', status);
    }

    notifyListeners();
  }
}
