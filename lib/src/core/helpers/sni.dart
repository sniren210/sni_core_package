// ignore_for_file: unused_field, unused_element

part of sni_core;

class Sni {
  static Sni instance = Sni._();

  Sni._();

  ThemeMode? _defaultThemeMode;

  final List<Interceptor> _interceptors = [];

  List<Locale>? _supportedLocales;

  static late List<SniPluginRegistrant> _registrants;

  static Future<void> initializeApp({
    FirebaseOptions? firebaseOptions,
    required List<SniPluginRegistrant> plugins,
    required List<Locale>? supportedLocales,

    /// base api domain, without http or https. e.g: sniren.my.id
    String? domain,
    List<Interceptor>? interceptors,

    //
    String? defaultLanguageCode,
    bool enablePerformanceMonitoring = true,

    /// Handle how UI render Error at HttpExceptions or InternalServerExceptions
    // TODO: config error handler
    // Map<Type, WidgetErrorBuilder>? errorHandlers,

    /// overrides firebase remote config if not null
    int? apiCallRequestsPerSec,

    /// overrides default theme mode if user not set
    ThemeMode? defaultThemeMode,
  }) async {
    _registrants = plugins;

    // TODO: config error handler
    //  if (errorHandlers != null && errorHandlers.isNotEmpty) {
    //   errors.errorHandlers.addAll(errorHandlers);
    // }

    final sni = Sni.instance;

    sni._defaultThemeMode = defaultThemeMode;

    Service.domain = domain ?? 'sniren.my.id';

    sni._defaultThemeMode = defaultThemeMode;

    // check every locales are supported by plugins
    if (supportedLocales != null) {
      if (!supportedLocales.every(
        (element) => sni._pluginSupportedLocales.contains(element),
      )) {
        final unsupportedLocales = supportedLocales
            .where((e) => sni._pluginSupportedLocales.contains(e))
            .toList();

        throw Exception(
          'Locales doesn\'t supported by plugins. [${unsupportedLocales.map((e) => e.languageCode).join(', ')}]',
        );
      }
    }
    sni._supportedLocales = supportedLocales;

    await _initializeDependencies(
      defaultLanguageCode: defaultLanguageCode,
    );

    timeago.setLocaleMessages('ja', timeago.JaMessages());
    timeago.setLocaleMessages('id', timeago.IdMessages());
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    sni._interceptors.clear();

    if (interceptors != null) {
      sni._interceptors.addAll(interceptors);
    }

    if (firebaseOptions != null) {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );

      await FirebasePerformance.instance
          .setPerformanceCollectionEnabled(kReleaseMode);
    }

    if (!kIsWeb) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);

      await FirebaseCrashlytics.instance.setUserIdentifier('no-user');
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    for (final plugin in plugins) {
      await plugin.register();
    }

    // TODO: konfig sign out
    // if (GetIt.I.isRegistered<AuthService>()) {
    //   final authService = GetIt.I.get<AuthService>();
    //   authService.addListener(() {
    //     if (authService.currentUser == null) {
    //       signOut();
    //     }
    //   });
    // }
  }

  static Future<void> signOut() async {
    for (final plugin in _registrants) {
      await plugin.onSignedOut();
    }
  }

  List<Interceptor> get _pluginInterceptors => _registrants.fold(
        [],
        (previousValue, element) => previousValue..addAll(element.interceptors),
      );

  List<SingleChildWidget> get _globalRepositories => _registrants.fold(
        [],
        (previousValue, element) =>
            previousValue..addAll(element.globalRepositories),
      );

  List<SingleChildWidget> get _authenticatedRepositories => _registrants.fold(
        [],
        (previousValue, element) =>
            previousValue..addAll(element.authenticatedRepositories),
      );

  List<LocalizationsDelegate> get localizationsDelegate => _registrants.fold(
        [],
        (previousValue, element) =>
            previousValue..addAll(element.localizationDelegates),
      );

  Set<Locale> get _pluginSupportedLocales => <Locale>{
        // ...XetiaCoreLocalizations.supportedLocales,
        ..._registrants.fold<List<Locale>>(
          <Locale>[],
          (previousValue, element) =>
              previousValue..addAll(element.supportedLocales),
        ),
        if (_supportedLocales != null) ..._supportedLocales!,
      };

  Set<Locale> get supportedLocales => <Locale>{
        if (_supportedLocales != null)
          ..._supportedLocales!
        else
          ..._pluginSupportedLocales,
      };

  List<SembastService> _getDatabaseSembastServices(
          BuildContext context, int version) =>
      _registrants.fold(
        [],
        (previousValue, element) => previousValue
          ..addAll(
            element.buildDatabaseSembastService(context, version),
          ),
      );

  List<SQLiteService> _getDatabaseSqliteServices(
          BuildContext context, int version) =>
      _registrants.fold(
        [],
        (previousValue, element) => previousValue
          ..addAll(
            element.buildDatabaseSqliteService(context, version),
          ),
      );
}

abstract class SniPluginRegistrant {
  Future<void> register() async {}

  List<LocalizationsDelegate> get localizationDelegates => [];
  List<Locale> get supportedLocales => [];
  List<SingleChildWidget> get globalRepositories => [];
  List<SingleChildWidget> get authenticatedRepositories => [];
  List<Interceptor> get interceptors => [];

  List<SembastService> buildDatabaseSembastService(
    BuildContext context,
    int databaseVersion,
  ) =>
      [];

  List<SQLiteService> buildDatabaseSqliteService(
    BuildContext context,
    int databaseVersion,
  ) =>
      [];

  FutureOr<void> onSignedOut() async {}
}
