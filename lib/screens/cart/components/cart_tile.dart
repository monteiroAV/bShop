import 'package:bhop/common/custom_icon_button.dart';
import 'package:bhop/models/cart_product.dart';
import 'package:bhop/screens/products/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.cartProduct);
  final CartProduct cartProduct;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductScreen(cartProduct.product)));
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(cartProduct.product.images.first,
                  fit: BoxFit.cover,),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cartProduct.product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${cartProduct.product.subtitle}: ${cartProduct.size}',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Consumer<CartProduct>(
                          builder: (_, cartProduct, __) {
                            if (cartProduct.hasStock) {
                              return Text(
                                'R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Text(
                                'Sem estoque suficiente',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) {
                    return Column(
                      children: <Widget>[
                        CustomIconButton(
                          iconData: Icons.add,
                          color: Colors.blue,
                          onTap: cartProduct.increment,
                        ),
                        Text(
                          '${cartProduct.quantity}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        CustomIconButton(
                          iconData: cartProduct.quantity > 1
                              ? Icons.remove
                              : Icons.delete_outline,
                          color: cartProduct.quantity > 1
                              ? Colors.blue
                              : Colors.red,
                          onTap: cartProduct.decrement,
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
