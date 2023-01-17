part of sni_core;

class _ThrottleInterceptor extends QueuedInterceptor {
  final int requestPerSecond;
  _ThrottleInterceptor({
    this.requestPerSecond = 10,
  });

  int _onGoingRequest = 0;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.method != 'GET') {
      handler.next(options);
      return;
    }

    if (_onGoingRequest >= 0) {
      _onGoingRequest++;
    }

    // throttling
    final delay = (1000 / requestPerSecond).round();
    await Future.delayed(
      Duration(
        milliseconds: delay,
      ),
    );

    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.method != 'GET') {
      handler.next(err);
      return;
    }

    if (_onGoingRequest > 0) {
      _onGoingRequest--;
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method != 'GET') {
      handler.next(response);
      return;
    }

    if (_onGoingRequest > 0) {
      _onGoingRequest--;
    }

    handler.next(response);
  }
}
