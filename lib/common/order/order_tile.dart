import 'package:bhop/common/order/cancel_order_dialog.dart';
import 'package:bhop/common/order/export_address_dialog.dart';
import 'package:bhop/common/order/order_product_tile.dart';
import 'package:bhop/models/order.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[300],
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: order.status == Status.canceled
                    ? Colors.red
                    : Colors.blue[300],
                fontSize: 14,
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: order.status == Status.preparing
                ? RaisedButton(
                    child: Text('Pagar Agora'),
                    onPressed: () {},
                  )
                : Container(),
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CancelOrderDialog(order),
                      );
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ExportAddressDialod(order.address),
                      );
                    },
                    textColor: Colors.blue[300],
                    child: const Text('Endereço'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
