part of sni_core;

class _ConnectivityInterceptor extends Interceptor {
  late final Connectivity connectivity;
  _ConnectivityInterceptor() {
    connectivity = Connectivity();
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await connectivity.checkConnectivity();
    String header = 'unknown';
    switch (result) {
      case ConnectivityResult.ethernet:
        header = 'ethernet';
        break;
      case ConnectivityResult.mobile:
        header = 'mobile';
        break;
      case ConnectivityResult.wifi:
        header = 'wifi';
        break;
      case ConnectivityResult.vpn:
        header = 'vpn';
        break;
      case ConnectivityResult.bluetooth:
        header = 'bluetooth';
        break;
      case ConnectivityResult.none:
        header = 'none';
        break;
    }

    options.headers['X-Connectivity'] = header;
    handler.next(options);
  }
}
