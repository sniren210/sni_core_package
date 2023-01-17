part of sni_core;

abstract class SoundSetting with ChangeNotifier {
  SoundSetting();

  Future<void> active();

  Future<void> disable();

  bool get status;
  Future<void> setStatus(bool status);
}

class SoundSettingImpl extends SoundSetting {
  final SharedPreferences preferences;

  SoundSettingImpl({required this.preferences});

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
    return preferences.getBool('sound_setting') ?? true;
  }

  @override
  Future<void> setStatus(bool? status) async {
    if (status == null) {
      await preferences.remove('sound_setting');
    } else {
      await preferences.setBool('sound_setting', status);
    }

    notifyListeners();
  }
}
