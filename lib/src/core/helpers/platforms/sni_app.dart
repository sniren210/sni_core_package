part of sni_core;

class SniApp extends StatelessWidget {
  final int databaseVersion;
  final List<SembastDatabaseHandler>? databaseSembastHandlers;
  final List<SQLiteDatabaseHandler>? databaseSqliteHandlers;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final Widget Function(BuildContext context, Widget? child)? builder;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegate;

  final Map<String, WidgetBuilder> routes;
  final Widget Function(BuildContext context)? onOfflineConnection;
  final String Function(BuildContext context) onGenerateTitle;
  final Widget Function(BuildContext context)? splashScreenBuilder;

  const SniApp({
    Key? key,
    this.databaseVersion = 1,
    this.databaseSembastHandlers,
    this.databaseSqliteHandlers,
    this.theme,
    this.darkTheme,
    this.builder,
    this.localizationsDelegate,
    required this.routes,
    this.onOfflineConnection,
    required this.onGenerateTitle,
    this.splashScreenBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ..._getConfigurationRepositories(),
          ...Sni.instance._globalRepositories,
        ],
        builder: (context, child) {
          final themeMode = context.watch<ThemeModeSetting>().mode;
          final localeName = context.watch<LocaleSetting>().value;

          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            child: MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              locale: Locale(localeName ?? 'en'),
              localizationsDelegates: [
                ...Sni.instance.localizationsDelegate,
                if (localizationsDelegate != null) ...localizationsDelegate!,
              ],
              supportedLocales: Sni.instance.supportedLocales,
              debugShowCheckedModeBanner: false,
              routes: routes,
              onGenerateTitle: onGenerateTitle,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Builder(
                      builder: (context) {
                        if (databaseSembastHandlers != null) {
                          final sembastServices = Sni.instance
                              ._getDatabaseSembastServices(
                                  context, databaseVersion);

                          return Nested(
                            children: [
                              SembastService(
                                databaseId: 'local-db',
                                version: databaseVersion,
                                handlers: databaseSembastHandlers!,
                              ),
                              ...sembastServices,
                            ],
                            child: builder?.call(context, child) ?? child!,
                          );
                        }
                        if (databaseSqliteHandlers != null) {
                          final sqliteServices = Sni.instance
                              ._getDatabaseSqliteServices(
                                  context, databaseVersion);

                          return Nested(
                            children: [
                              SQLiteService(
                                databaseId: 'local-db',
                                version: databaseVersion,
                                handlers: databaseSqliteHandlers!,
                              ),
                              ...sqliteServices,
                            ],
                            child: builder?.call(context, child) ?? child!,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    if (splashScreenBuilder != null)
                      Builder(
                        builder: (context) {
                          final splashState =
                              context.watch<SplashscreenSetting>().value;
                          if (splashState != SplashscreenState.closed) {
                            return splashScreenBuilder!(context);
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                  ],
                );
              },
            ),
          );
        });
  }
}
