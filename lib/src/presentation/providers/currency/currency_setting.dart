part of sni_core;

abstract class CurrencySetting with ChangeNotifier {
  final List<String>? supportedCurrencies;
  final String? defaultValue;

  CurrencySetting({
    required this.defaultValue,
    required this.supportedCurrencies,
  });

  Future<void> setValue(String? value);
  String? get value;
}

class CurrencySettingImpl extends CurrencySetting {
  final SharedPreferences preferences;

  CurrencySettingImpl({
    required String? defaultValue,
    required this.preferences,
    required List<String>? supportedCurrencies,
  }) : super(
          defaultValue: defaultValue,
          supportedCurrencies: supportedCurrencies,
        );

  @override
  String get value =>
      preferences.getString('currency_setting') ?? defaultValue ?? 'USD';

  @override
  Future<void> setValue(String? value) async {
    if (value != null &&
        supportedCurrencies != null &&
        !supportedCurrencies!.contains(value)) {
      throw UnsupportedCurrencyException();
    }

    if (value == null) {
      await preferences.remove('currency_setting');
    } else {
      await preferences.setString('currency_setting', value);
    }

    notifyListeners();
  }
}

class UnsupportedCurrencyException implements Exception {}
