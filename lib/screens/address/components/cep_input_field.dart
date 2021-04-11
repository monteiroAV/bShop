import 'package:bhop/common/custom_icon_button.dart';
import 'package:bhop/models/address.dart';
import 'package:bhop/models/cart_manager.dart';
import 'package:brasil_fields/formatter/cep_input_formatter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    if (widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12.345-678',
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty)
                return 'Campo obrigatório';
              else if (cep.length != 10) return 'CEP Inválido';
              return null;
            },
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue[200]),
              backgroundColor: Colors.transparent,
            ),
          Container(
            margin: EdgeInsets.only(top: 8),
            height: !cartManager.loading ? 44 : 0,
            color: cartManager.loading ? Colors.transparent : Colors.blue,
            child: FlatButton(
              onPressed: !cartManager.loading
                  ? () async {
                      if (Form.of(context).validate()) {
                        try {
                          await context
                              .read<CartManager>()
                              .getAddress(cepController.text);
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  : null,
              textColor: Colors.white,
              child: !cartManager.loading
                  ? const Text('Buscar CEP', style: TextStyle(fontSize: 18),)
                  : Container(),
            ),
          )
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: Colors.blue[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: Colors.blue[200],
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
  }
}
