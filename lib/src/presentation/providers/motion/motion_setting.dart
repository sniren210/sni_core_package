part of sni_core;

abstract class MotionSetting with ChangeNotifier {
  MotionSetting();

  Future<void> active();

  Future<void> disable();

  bool get status;
  Future<void> setStatus(bool status);
}

class MotionSettingImpl extends MotionSetting {
  final SharedPreferences preferences;

  MotionSettingImpl({required this.preferences});

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
    return preferences.getBool('motion_setting') ?? true;
  }

  @override
  Future<void> setStatus(bool? status) async {
    if (status == null) {
      await preferences.remove('motion_setting');
    } else {
      await preferences.setBool('motion_setting', status);
    }

    notifyListeners();
  }
}
