import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print('Request[${options.method}] => PATH: ${options.path}');

    // TODO: implement onRequest
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print('Response[${response.statusCode}] => PATH: ${response.request.path}');

    // TODO: implement onResponse
    return super.onResponse(response);
  }

  @override
  Future onError(DioError e) {
    print('Response[${e.response.statusCode}] => PATH: ${e.request.path}');

    // TODO: implement onError
    return super.onError(e);
  }
}
