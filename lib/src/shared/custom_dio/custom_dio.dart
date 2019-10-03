import 'package:dio/dio.dart';
import 'package:rest/src/shared/constants.dart';
import 'package:rest/src/shared/custom_dio/interceptor_auth.dart';
import 'package:rest/src/shared/custom_dio/interceptors.dart';


class CustomDio  {
  final Dio client;

  CustomDio(this.client){
    client.options = BaseOptions();
    client.options.baseUrl = BASE_URL;

    client.interceptors.add(CustomInterceptors());
    client.interceptors.add(AuthInterceptor());

    client.options.connectTimeout = 5000;
  }
}