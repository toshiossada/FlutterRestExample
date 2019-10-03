import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rest/src/repositories/post_repository.dart';
import 'package:rest/src/shared/models/post_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {
  final PostRepository repo;

  HomeBloc(this.repo);

  var listPost = BehaviorSubject<List<PostModel>>();
  Sink<List<PostModel>> get responseIn => listPost.sink;
  Observable<List<PostModel>> get responseOut => listPost.stream;

  void getPosts() async {
    try {
      var res = await repo.getPosts();
      responseIn.add(res);
    } catch (e) {
      listPost.addError(e);
    }
  }

  deletePost(PostModel data, int id) async {
    try {
      var response = await repo.delete(id);
      return response;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    listPost.close();
    super.dispose();
  }
}
