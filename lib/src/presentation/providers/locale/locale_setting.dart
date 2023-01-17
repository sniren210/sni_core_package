part of sni_core;

abstract class LocaleSetting with ChangeNotifier {
  final List<String> supportedLocales;
  final String? defaultValue;

  LocaleSetting({
    this.defaultValue,
    required this.supportedLocales,
  });

  Future<void> setValue(String? value);
  String? get value;
  bool get isUsingDefaultValue;
  bool isSupported(String value);
}

class LocaleSettingImpl extends LocaleSetting {
  final SharedPreferences preferences;

  LocaleSettingImpl({
    required String? defaultValue,
    required List<String> supportedLocales,
    required this.preferences,
  }) : super(
          supportedLocales: supportedLocales,
          defaultValue: defaultValue,
        );

  @override
  String get value =>
      preferences.getString('locale_setting') ?? defaultValue ?? 'en';

  @override
  Future<void> setValue(String? value) async {
    if (value != null && !isSupported(value)) {
      throw UnsupportedLocaleException();
    }

    if (value == null) {
      await preferences.remove('locale_setting');
    } else {
      await preferences.setString('locale_setting', value);
    }

    notifyListeners();
  }

  @override
  bool get isUsingDefaultValue => !preferences.containsKey('locale_setting');

  @override
  bool isSupported(String value) => supportedLocales.contains(value);
}

class UnsupportedLocaleException implements Exception {}
