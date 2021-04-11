import 'package:bhop/common/order/order_product_tile.dart';
import 'package:bhop/models/cart_product.dart';
import 'package:bhop/models/order.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bhop/screens/mercado_pago/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';

int resultadoMP = 0;

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key key, this.prefIdMP, this.orderId})
      : super(key: key);

  final Order orderId;
  final String prefIdMP;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState(prefIdMP);
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  //final String orderId;
  final String prefIdMP;

  _ConfirmationScreenState(this.prefIdMP);
  @override
  Widget build(BuildContext context) {
    double price = widget.orderId.price;
    //String order = widget.orderId.formattedId;
    print(widget.prefIdMP);
    print(price);

    var mp = MP(globals.mpClientID, globals.mpClientSecret);
    var resultRefIdMP;

    Future createPayInfo(orderID, payId) async {
      await Firestore.instance
          .collection("ordens")
          .document(orderID)
          .updateData({
        "payInfo": {
          'id': payId.toString(),
        }
      });
    }

    /*Future<Map<String, dynamic>> preferenceGetMP() async {
      //CartProduct cartProduct;

      print("${globals.mpClientID} , ${globals.mpClientSecret}");

      var preference = {
        "items": [
          {
            "title": "B-Shop",
            "quantity": 1,
            "currency_id": "BRL",
            "unit_price": price
          }
        ],
      };

      var resultRefIdMP = await mp.createPreference(preference);
      //print(resultRefIdMP);

      return resultRefIdMP;
    }*/

    /*Future<void> executarMercadoPago() async {
      preferenceGetMP().then((result) {
        if (result != null) {
          var preferenceID = result['response']['id'];
          print("preferenceID: ${preferenceID}");
          try {} on PlatformException catch (e) {
            print(e.message);
          }
        }
      });
    }*/

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Card(
                margin: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.orderId.formattedId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'R\$ ${widget.orderId.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: widget.orderId.items.map((e) {
                        return OrderProductTile(e);
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                                color: Colors.lightGreen[900],
                                child: Text(
                                  'Pagar Agora',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                onPressed: () async {
                                  var result = await MercadoPagoMobileCheckout
                                      .startCheckout(
                                          globals.mpTESTPublicKey,
                                          
                                          widget.prefIdMP);
                                  print(result.id);
                                  
                                  print(price);
                                  await createPayInfo(widget.orderId, price);
                                  setState(() {
                                    resultadoMP = result.id;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                'Continuar Comprando',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => BaseScreen()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
