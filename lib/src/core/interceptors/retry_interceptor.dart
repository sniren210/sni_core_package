part of sni_core;

class _RetryService extends ApiService {
  _RetryService() : super(HttpService());
}

class _RetryInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.type == DioErrorType.response &&
        err.requestOptions.method == 'GET') {
      if ((err.response?.statusCode ?? 0) >= 500) {
        final options = err.requestOptions;
        int attempt = options.extra['retry_attempt'] ?? 0;
        attempt++;

        if (attempt > 15) {
          handler.reject(err);
          return;
        }

        final service = _RetryService();
        service.options = BaseOptions(
          headers: {
            'Accept': 'application/json',
          },
          baseUrl: options.baseUrl,
          contentType: 'application/json',
          receiveDataWhenStatusError: true,
          followRedirects: true,
          setRequestContentTypeWhenNoPayload: true,
        );

        try {
          await Future.delayed(
            const Duration(seconds: 1),
          );

          final response = await service.request(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            cancelToken: options.cancelToken,
            options: Options(
              headers: options.headers,
              contentType: options.contentType,
              extra: {
                'retry_attempt': attempt,
              },
            ),
          );

          handler.resolve(response);
        } on DioError catch (e) {
          handler.reject(e);
        } finally {
          service.dispose();
        }

        return;
      }
    }

    handler.next(err);
  }
}
