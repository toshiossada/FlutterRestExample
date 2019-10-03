import 'package:flutter/material.dart';
import 'package:rest/src/pages/create/create_page.dart';
import 'package:rest/src/pages/update/update_page.dart';
import 'package:rest/src/shared/models/post_model.dart';
import 'package:rest/src/pages/home/home_bloc.dart';
import 'package:rest/src/pages/home/home_module.dart';
import 'package:rest/src/shared/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bloc = HomeModule.to.getBloc<HomeBloc>();

  @override
  void initState() {
    bloc.getPosts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<PostModel>>(
          stream: bloc.responseOut,
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error.toString()),
              );
            else if (snapshot.hasData)
              return Column(
                  children: snapshot.data
                      .map((data) => ListTile(
                            title: Text(data.title),
                            onLongPress: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(snapshot: data,)));

                              var actionOk = <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ];

                              var actiontConfirm = <Widget>[
                                FlatButton(
                                  child: Text('Confirmar'),
                                  onPressed: () async {
                                    try {
                                      var retun =
                                          await bloc.deletePost(data, data.id);

                                      Navigator.pop(context);

                                      if (retun == 200) {
                                        bloc.getPosts();

                                        Utils.showAlert(
                                            context: context,
                                            title: 'Ação',
                                            body: 'Post deletado com sucesso!',
                                            actions: actionOk);
                                      }
                                    } catch (e) {
                                      Utils.showAlert(
                                          context: context,
                                          title: 'Ação',
                                          body: 'Erro ao deletar!',
                                          actions: actionOk);
                                    }
                                  },
                                ),
                                FlatButton(
                                  child: new Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ];

                              Utils.showAlert(
                                  context: context,
                                  title: 'Corfirme a ação',
                                  body: 'Deseja realmente excluir registro?',
                                  actions: actiontConfirm);
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdatePage(
                                            snapshot: data,
                                          )));
                            },
                          ))
                      .toList());
            else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePage(
                        onSuccess: bloc.getPosts,
                      )));
        },
      ),
    );
  }
}
