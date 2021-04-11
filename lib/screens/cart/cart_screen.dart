import 'package:bhop/common/price_card.dart';
import 'package:bhop/models/cart_manager.dart';
import 'package:bhop/screens/address/address_screen.dart';
import 'package:bhop/screens/cart/components/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.items.isEmpty) 
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Nenhum produto no Carrinho!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
           
            return ListView(
              children: <Widget>[
                Column(
                  children: cartManager.items.map((cartProduct) {
                    return CartTile(cartProduct);
                  }).toList(),
                ),
                PriceCard(
                  onPressed: cartManager.isCartValid
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddressScreen()));
                        }
                      : null,
                  buttonText: 'Continuar para Entrega',
                ),
              ],
            );
          
        },
      ),
    );
  }
}
