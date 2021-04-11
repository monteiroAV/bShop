import 'package:bhop/helpers/validator.dart';
import 'package:bhop/models/user.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:bhop/screens/login/components/recuperar_senha.dart';
import 'package:bhop/screens/login/login_manager.dart';
import 'package:bhop/screens/login/widget/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClienteLogin extends StatefulWidget {
  @override
  _ClienteLoginState createState() => _ClienteLoginState();
}

class _ClienteLoginState extends State<ClienteLogin> {
  bool visible = false;
  bool switchContol = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                const SizedBox(height: 8),
                LoginFormField(
                  enabled: !userManager.loading,
                  controller: passController,
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  obscure: visible == false ? true : false,
                  hint: 'Senha',
                  prefix: Icon(
                    Icons.lock,
                    color: Colors.white70,
                  ),
                  suffixIcon: visible == false
                      ? IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              visible = true;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              visible = false;
                            });
                          },
                        ),
                  validator: (pass) {
                    if (pass.length < 6) return 'Senha inválida';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RecuperarSenha()));
                          },
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.read<LoginManager>().setPage(1);
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  color: userManager.loading ? Colors.transparent : Colors.blue,
                  height: 50,
                  child: FlatButton(

                      // ignore: sort_child_properties_last
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                userManager.signIn(
                                  user: User(
                                    email: emailController.text,
                                    password: passController.text,
                                  ),
                                  onFail: (e) {},
                                  onSuccess: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BaseScreen()));
                                  },
                                );
                              }
                            }),
                )
              ],
            );
          },
        ));
  }
}
