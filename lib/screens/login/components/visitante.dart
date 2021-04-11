import 'package:bhop/helpers/validator.dart';
import 'package:bhop/models/user.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:bhop/screens/login/widget/login_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitanteLogin extends StatefulWidget {
  @override
  _VisitanteLoginState createState() => _VisitanteLoginState();
}

class _VisitanteLoginState extends State<VisitanteLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final User user = User();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LoginFormField(
            controller: nameController,
            obscure: false,
            hint: 'Nome',
            prefix: Icon(
              Icons.account_circle,
              color: Colors.black45,
            ),
            validator: (name) {
              if (name.isEmpty) {
                return 'Nome vazio';
              }
              return null;
            },
            onSaved: (name) => user.name = name,
          ),
          const SizedBox(height: 8),
          LoginFormField(
            controller: emailController,
            obscure: false,
            hint: 'E-mail',
            textInputType: TextInputType.emailAddress,
            prefix: Icon(
              Icons.account_circle,
              color: Colors.black45,
            ),
            validator: (email) {
              if (!emailValid(email)) {
                return 'E-mail inválido';
              }
              return null;
            },
            onSaved: (email) => user.email = email,
          ),
          const SizedBox(height: 8),
          LoginFormField(
            controller: phoneController,
            obscure: false,
            hint: 'Telefone',
            textInputType: TextInputType.number,
            prefix: Icon(
              Icons.account_circle,
              color: Colors.black45,
            ),
            validator: (phone) {
              if (phone.isEmpty || phone.length < 10) {
                return 'Número inválido';
              }
              return null;
            },
            onSaved: (phone) => user.phone = phone,
          ),
          RaisedButton(
              color: Colors.blue,
              // ignore: sort_child_properties_last
              child: const Text(
                'Visite a Loja',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () async{
                debugPrint('true');
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                 await Firestore.instance
                      .collection('visitante')
                      .document()
                      .setData({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                  });

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BaseScreen()));
                }
              }),
        ],
      ),
    );
  }
}
