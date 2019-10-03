import 'package:dio/dio.dart';
import 'package:rest/src/app/app_module.dart';
import 'package:rest/src/shared/auth/auth_bloc.dart';
import 'package:rest/src/shared/custom_dio/custom_dio.dart';

class AuthInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    print('Request[${options.method}] => PATH: ${options.path}');

    var auth = AppModule.to.getBloc<AuthBloc>();
    var dio = AppModule.to.getDependency<CustomDio>();

    var jwt = auth.jwt;
    if (jwt == null) {
      dio.client.lock();
      jwt = await auth.login();

      options.headers.addAll({"Authorization": jwt});

      dio.client.unlock();
    }

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
    if (e.response.statusCode == 401) {
      var auth = AppModule.to.getBloc<AuthBloc>();
      var dio = AppModule.to.getDependency<CustomDio>();

      var options = e.response.request;

      if (auth.jwt != options.headers['Authorization']) {
        options.headers['Authorization'] = auth.jwt;
        return dio.client.request(options.path, options: options);
      }
      dio.client.lock();
      dio.client.interceptors.responseLock.lock();
      dio.client.interceptors.errorLock.lock();

      return auth.login().then((d) {
        options.headers['Authorization'] = d;
      }).whenComplete(() {
        dio.client.unlock();
        dio.client.interceptors.responseLock.unlock();
        dio.client.interceptors.errorLock.unlock();
      }).then((e) => dio.client.request(options.path, options: options));
    }

    // TODO: implement onError
    return super.onError(e);
  }
}
