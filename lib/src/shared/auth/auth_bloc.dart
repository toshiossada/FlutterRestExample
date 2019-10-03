import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rest/src/app/app_module.dart';
import 'package:rest/src/shared/auth/auth_repository.dart';

class AuthBloc extends BlocBase {
  AuthRepository repo;
  String jwt;

  AuthBloc(){
    repo = AppModule.to.getDependency<AuthRepository>();
  }

  Future<String> login() async{
    var res = await repo.login({
      'email': 'flutter@gmail.com',
      'password': '123456789'
    });

    jwt = res['token'];

    return jwt;
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}
