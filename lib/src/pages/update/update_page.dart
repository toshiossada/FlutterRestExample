import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rest/src/pages/home/home_module.dart';
import 'package:rest/src/pages/update/update_bloc.dart';
import 'package:rest/src/shared/models/post_model.dart';

class UpdatePage extends StatefulWidget {
  final Function onSuccess;
  final PostModel snapshot;

  const UpdatePage({Key key, this.onSuccess, @required this.snapshot});
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var bloc = HomeModule.to.getBloc<UpdateBloc>();

  Controller controller;

  @override
  void initState() {
    bloc.id = widget.snapshot.id;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();

    super.didChangeDependencies();
  }

  @override
  void onDispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
      ),
      body: StreamBuilder<int>(
        stream: bloc.responseOut,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text("${snapshot.error.toString()}"),
            );

          if (snapshot.hasData) {
            if (snapshot.data == 0)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              Timer(
                Duration(seconds: 1),
                () {
                  Navigator.pop(context);
                },
              );
              return Center(
                child: Text(
                  'Atualizado com sucesso!',
                  style: TextStyle(fontSize: 25),
                ),
              );
            }
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.snapshot.title,
                          onSaved: (value) => bloc.title = value,
                          validator: (value) => value.isEmpty
                              ? 'O título não pode ser nulo'
                              : null,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextFormField(
                          initialValue: widget.snapshot.body,
                          onSaved: (value) => bloc.body = value,
                          validator: (value) =>
                              value.isEmpty ? 'O body não pode ser nulo' : null,
                          maxLines: 3,
                          decoration: InputDecoration(labelText: 'Body'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Enviar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (controller.validate()) {
                        bloc.postIn.add(PostModel(
                            body: bloc.body, title: bloc.title, userId: 1));
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class Controller {
  var formKey = GlobalKey<FormState>();

  bool validate() {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();

      return true;
    } else {
      return false;
    }
  }
}
