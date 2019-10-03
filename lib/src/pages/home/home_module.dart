import 'package:rest/src/pages/create/create_bloc.dart';
import 'package:rest/src/app/app_module.dart';
import 'package:rest/src/repositories/post_repository.dart';
import 'package:rest/src/pages/home/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rest/src/pages/home/home_page.dart';
import 'package:rest/src/pages/update/update_bloc.dart';
import 'package:rest/src/shared/custom_dio/custom_dio.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CreateBloc(HomeModule.to.getDependency<PostRepository>()), singleton: false),
        Bloc((i) => UpdateBloc(HomeModule.to.getDependency<PostRepository>()), singleton: false),
        Bloc((i) => HomeBloc(HomeModule.to.getDependency<PostRepository>())),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency(
            (i) => PostRepository(AppModule.to.getDependency<CustomDio>())),
      ];

  @override
  Widget get view => HomePage();

  static Inject get to => Inject<HomeModule>.of();
}
