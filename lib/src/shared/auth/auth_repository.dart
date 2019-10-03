import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:rest/src/shared/constants.dart';
import 'package:rest/src/shared/custom_dio/interceptors.dart';

class AuthRepository extends Disposable {
  Dio _client;

  AuthRepository() {
    _client = Dio();
    _client.options.baseUrl = BASE_URL;
    _client.interceptors.add(CustomInterceptors());
  }

  Future<Map> login(Map<String, dynamic> data) async {
    try {
      var response = await _client.post('/sign_in', data: data);
      return response.data;
    } on DioError catch (e) {
      return {'token': ''};
      //throw e.message;
    }
  }

  @override
  void dispose() {}
}
