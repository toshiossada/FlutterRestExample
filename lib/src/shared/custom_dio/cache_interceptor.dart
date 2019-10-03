import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    print('Request[${options.method}] => PATH: ${options.path}');
    options.extra.addAll({'refresh': true});

    if (options.extra.containsKey('refresh')) {
      if (options.extra['refresh']) {
        return options;
      } else {
        return getCache(options.uri);
      }
    }

    // TODO: implement onRequest
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    print('Response[${response.statusCode}] => PATH: ${response.request.path}');
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('${response.request.uri}', jsonEncode(response.data));

    return super.onResponse(response);
  }

  @override
  Future onError(DioError e) async {
    print('Response[${e.response.statusCode}] => PATH: ${e.request.path}');
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.DEFAULT) {
      return getCache(e.request.uri);
    } else {
      return e;
    }
  }

  getCache(Uri uri) async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('$uri')) {
      var res = jsonDecode(prefs.getString('$uri'));

      return Response(data: res, statusCode: 200);
    } else {
      return Response(data: null, statusCode: 500);
    }
  }
}
