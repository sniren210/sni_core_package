part of sni_core;

@InjectableInit(
  initializerName: r'initInjectable',
  preferRelativeImports: false,
  asExtension: false,
  ignoreUnregisteredTypes: [
    SharedPreferences,
  ],
)
Future<void> _initializeDependencies({
  String? defaultCurrencyCode,
  String? defaultCountryCode,
  String? defaultLanguageCode,
}) async {
  // _injectDependencies();

  // core
  final preferences = await SharedPreferences.getInstance();
  GetIt.I.registerLazySingleton(() => preferences);

  // settings
  await _initializeSettings(
    defaultCurrencyCode: defaultCurrencyCode,
    defaultCountryCode: defaultCountryCode,
    defaultLanguageCode: defaultLanguageCode,
  );

  // final interceptors = [
  //   _ThrottleInterceptor(
  //     requestPerSecond: 200,
  //   ),
  //   _ConfigInterceptor(
  //     countrySetting: GetIt.I(),
  //     currencySetting: GetIt.I(),
  //     localeSetting: GetIt.I(),
  //     themeModeSetting: GetIt.I(),
  //     vibrationSetting: GetIt.I(),
  //     soundSetting: GetIt.I(),
  //     motionSetting: GetIt.I(),
  //   ),
  //   _RetryInterceptor(),
  //   _ConnectivityInterceptor(),
  // ];

  // GetIt.I.registerSingleton(
  //   DefaultInterceptors(
  //     interceptors: [
  //       if (!isWebPlatform) _UserAgentInterceptor(),
  //       ...interceptors,
  //       if (Xetia.instance._enablePerformanceMonitoring)
  //         _performanceInterceptor,
  //     ],
  //   ),
  // );

  // GetIt.I.registerFactory<HttpService>(
  //   () => HttpService(
  //     BaseOptions(
  //       contentType: 'application/json',
  //       responseType: ResponseType.json,
  //     ),
  //   )..interceptors.addAll([
  //       ...GetIt.I<DefaultInterceptors>().interceptors,
  //       ...Xetia.instance._pluginInterceptors,
  //     ]),
  // );

  // @Injectable and @Singleton
  initInjectable(GetIt.I);
}
