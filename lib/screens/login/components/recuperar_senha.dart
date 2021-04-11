import 'package:bhop/helpers/validator.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/login/widget/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecuperarSenha extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
                              'Recuperar Senha',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 30),
                            LoginFormField(
                              enabled: !userManager.loading,
                              controller: emailController,
                              textInputType: TextInputType.emailAddress,
                              obscure: false,
                              hint: 'Email',
                              prefix: Icon(
                                Icons.account_circle,
                                color: Colors.white70,
                              ),
                              validator: (email) {
                                if (!emailValid(email)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 44,
                              child: RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    if (emailController.text.isEmpty) {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            'Insira seu e-mail para recuperação!'),
                                        backgroundColor: Colors.redAccent,
                                        duration: const Duration(seconds: 2),
                                      ));
                                    } else {
                                      userManager
                                          .recoverPass(emailController.text);
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content:
                                            const Text('Confira seu e-mail'),
                                        backgroundColor: Colors.blueAccent,
                                        duration: const Duration(seconds: 2),
                                      ));
                                    }
                                  },
                                  child: const Text(
                                    'Recuperar Senha',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                            )
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
