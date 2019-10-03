import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rest/src/repositories/post_repository.dart';
import 'package:rest/src/shared/models/post_model.dart';
import 'package:rxdart/rxdart.dart';

class UpdateBloc extends BlocBase {
  final PostRepository repo;

  UpdateBloc(this.repo) {
    responseOut = post.switchMap(observablePost);
  }

  String title;
  String body;  
  int id;

  var post = BehaviorSubject<PostModel>();

  PostModel get postValue => post.value;
  Observable<int> responseOut;
  Sink<PostModel> get postIn => post.sink;

  Stream<int> observablePost(PostModel data) async* {
    yield 0;
    try {
      var response = await repo.updatePost(data.toJson(), id);
      yield response;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    post.close();
    super.dispose();
  }
}
