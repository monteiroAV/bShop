import 'package:bhop/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:bhop/screens/mercado_pago/globals.dart' as globals;

class CarrinhoModelo extends Model {
    User user;

   var mp = MP(globals.mpClientID, globals.mpClientSecret);
  var resultRefIdMP;

   bool isLoading = false;
  Future<Map<String, dynamic>> preferenceGetMP() async {
    isLoading = true;
    notifyListeners();



    var preference = {
      "items": [
        {
          "title": "Produtos Preta Info&Cel",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": 20
        }
      ],
      "payer": {
        "email": user.email,
        "name": user.name
      },
      "payment_methods": {
        "excluded_payment_types": [
          {"id": "atm"},
        ]
      },
    };

    resultRefIdMP = await mp.createPreference(preference);
    print(resultRefIdMP);

    isLoading = false;
    notifyListeners();

    return resultRefIdMP;
  }

  Future createPayInfo(orderID, payId) async {
    isLoading = true;
    notifyListeners();

    await Firestore.instance.collection("ordens").document(orderID).updateData({
      "payInfo": {
        'id': payId.toString(),
      }
    });
    isLoading = false;
    notifyListeners();
  }
}
