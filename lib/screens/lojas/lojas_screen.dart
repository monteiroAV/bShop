import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/base/widget/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LojasScreen extends StatefulWidget {
  @override
  _LojasScreenState createState() => _LojasScreenState();
}

class _LojasScreenState extends State<LojasScreen> {
  bool editing = false;
  String text;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text('Loja'),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return editing == false
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              editing = true;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              
                            Firestore.instance
                                .collection('lojas')
                                .document('MzxvzIHwsbmUKGEbAkjs')
                                .updateData({'description': text});
                            }
                            setState(() {
                              editing = false;
                            });
                          },
                        );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('lojas')
              .document('MzxvzIHwsbmUKGEbAkjs')
              .snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Deu Erro');
            }
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: editing == false
                    ? Text(snapshot.data['description'],
                    style: TextStyle(color: Colors.white,
                    fontSize: 16,),)
                    : Form(
                      key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: snapshot.data['description'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Descrição',
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              validator: (desc) {
                                if (desc.length < 6)
                                  return 'Descrição muito curta';
                                return null;
                              },
                              onSaved: (desc) => text = desc,
                            ),
                          ],
                        ),
                      ),
              );
            }
          },
        ));
  }
}

//MzxvzIHwsbmUKGEbAkjs
