import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:rest/src/shared/custom_dio/custom_dio.dart';
import 'package:rest/src/shared/models/post_model.dart';

class PostRepository extends Disposable {
  final CustomDio dio;

  PostRepository(this.dio);

  @override
  void dispose() {}

  Future<List<PostModel>> getPosts() async {
    try {
      var response = await dio.client.get('/posts',
          options: Options(extra: {'refresh': false}));

      return (response.data as List)
          .map((item) => PostModel.fromJson(item))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> createPost(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post('/posts', data: data);

      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> updatePost(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.put('/posts/$id', data: data);

      return response.statusCode;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<int> delete(int id) async {
    try {
      var response = await dio.client.delete('/posts/$id');

      return response.statusCode;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
