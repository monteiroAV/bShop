import 'package:bhop/helpers/validator.dart';
import 'package:bhop/models/user.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:bhop/screens/login/login_manager.dart';
import 'package:bhop/screens/login/widget/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();
  bool senha = false;
  bool confSenha = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.pink[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: 150,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo1.png'),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Consumer<UserManager>(
                      builder: (_, userManager, __) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'Cadastro',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 15),
                            LoginFormField(
                              obscure: false,
                              enabled: !userManager.loading,
                              hint: 'Nome Completo',
                              prefix: Icon(
                                Icons.account_circle,
                                color: Colors.black45,
                              ),
                              validator: (name) {
                                if (name.isEmpty) {
                                  return 'Campo obrigatório';
                                } else if (name.trim().split(' ').length <= 1) {
                                  return 'Preencha seu nome completo';
                                }
                                return null;
                              },
                              onSaved: (name) => user.name = name,
                            ),
                            const SizedBox(height: 8),
                            LoginFormField(
                              enabled: !userManager.loading,
                              obscure: false,
                              hint: 'E-mail',
                              textInputType: TextInputType.emailAddress,
                              prefix: Icon(
                                Icons.account_circle,
                                color: Colors.black45,
                              ),
                              validator: (email) {
                                if (email.isEmpty) {
                                  return 'Campo obrigatório';
                                } else if (!emailValid(email)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                              onSaved: (email) => user.email = email,
                            ),
                            const SizedBox(height: 8),
                            LoginFormField(
                              enabled: !userManager.loading,
                              obscure: senha == false ? true : false,
                              hint: 'Senha',
                              prefix: Icon(
                                Icons.account_circle,
                                color: Colors.black45,
                              ),
                              suffixIcon: senha == false
                                  ? IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          senha = true;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          senha = false;
                                        });
                                      },
                                    ),
                              validator: (pass) {
                                if (pass.isEmpty) {
                                  return 'Campo obrigatório';
                                } else if (pass.length < 6) {
                                  return 'Senha muito curta';
                                }
                                return null;
                              },
                              onSaved: (pass) => user.password = pass,
                            ),
                            const SizedBox(height: 8),
                            LoginFormField(
                              enabled: !userManager.loading,
                              obscure: confSenha == false ? true : false,
                              hint: 'Confirme a Senha',
                              prefix: Icon(
                                Icons.account_circle,
                                color: Colors.black45,
                              ),
                              suffixIcon: confSenha == false
                                  ? IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          confSenha = true;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          confSenha = false;
                                        });
                                      },
                                    ),
                              validator: (pass) {
                                if (pass.isEmpty) {
                                  return 'Campo obrigatório';
                                } else if (pass.length < 6) {
                                  return 'Senha muito curta';
                                }
                                return null;
                              },
                              onSaved: (pass) => user.confirmPassword = pass,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              color: userManager.loading
                                  ? Colors.transparent
                                  : Colors.blue,
                              height: 50,
                              child: FlatButton(
                                  color: Colors.blue,
                                  // ignore: sort_child_properties_last
                                  child: userManager.loading
                                      ? const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        )
                                      : const Text(
                                          'Cadastro',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                  onPressed: userManager.loading
                                      ? null
                                      : () {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            if (user.password !=
                                                user.confirmPassword) {
                                              scaffoldKey.currentState
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Senhas não coincidem!',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }
                                            userManager.signUp(
                                                user: user,
                                                onSuccess: () async {
                                                  context.read<LoginManager>().setPage(0);
                                                },
                                                onFail: (e) {
                                                  scaffoldKey.currentState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Falha ao cadastrar: $e'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                });
                                          }
                                        }),
                            ),
                            FlatButton(
                                onPressed: () {
                                  context.read<LoginManager>().setPage(0);
                                },
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 18),
                                ))
                          ],
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
