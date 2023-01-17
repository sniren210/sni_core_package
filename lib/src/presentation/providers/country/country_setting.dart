part of sni_core;

abstract class CountrySetting with ChangeNotifier {
  final String? defaultValue;
  CountrySetting({
    this.defaultValue,
  });

  Future<void> setValue(String? value);
  String? get value;
}

class CountrySettingImpl extends CountrySetting {
  final SharedPreferences preferences;

  CountrySettingImpl({
    required String? defaultValue,
    required this.preferences,
  }) : super(defaultValue: defaultValue);

  @override
  String? get value =>
      preferences.getString('country_setting') ?? defaultValue ?? 'USA';

  @override
  Future<void> setValue(String? value) async {
    if (value == null) {
      await preferences.remove('country_setting');
    } else {
      await preferences.setString('country_setting', value);
    }

    notifyListeners();
  }
}
