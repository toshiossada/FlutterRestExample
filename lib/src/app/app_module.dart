import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest/src/app/app_widget.dart';
import 'package:rest/src/app/app_bloc.dart';
import 'package:rest/src/shared/auth/auth_bloc.dart';
import 'package:rest/src/shared/auth/auth_repository.dart';
import 'package:rest/src/shared/custom_dio/custom_dio.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => AppBloc(),
        ),
        Bloc(
          (i) => AuthBloc(),
        )
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Dio()),
        Dependency((i) => CustomDio(i.getDependency<Dio>())),
        Dependency((i) => AuthRepository()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
