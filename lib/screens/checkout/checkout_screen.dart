import 'package:bhop/common/price_card.dart';
import 'package:bhop/models/cart_manager.dart';
import 'package:bhop/models/cart_product.dart';
import 'package:bhop/models/checkout_manager.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:bhop/screens/cart/cart_screen.dart';
import 'package:bhop/screens/confirmation/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffolfKey = GlobalKey<ScaffoldState>();
  CartProduct cartProduct;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffolfKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              );
            }
            return ListView(
              children: <Widget>[
                PriceCard(
                  buttonText: 'Finalizar Pedido',
                  onPressed: () async {
                    Map prefIdMP = await CartProduct().preferenceGetMP();
                    checkoutManager.checkout(
                      onStockFail: (e) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CartScreen()));
                      },
                      onSuccess: (order, prefID) async {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => BaseScreen()));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(
                                  orderId: order,
                                  prefIdMP: prefIdMP['response']['id'],
                                )));
                      },
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
