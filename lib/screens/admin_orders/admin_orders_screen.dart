
import 'package:bhop/common/custom_icon_button.dart';
import 'package:bhop/common/empty_card.dart';
import 'package:bhop/common/order/order_tile.dart';
import 'package:bhop/models/admin_orders_manager.dart';
import 'package:bhop/models/order.dart';
import 'package:bhop/screens/base/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: <Widget>[
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.blue[300],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.blue[300],
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            filteredOrders[index],
                            showControls: true,
                          );
                        }),
                  ),
                  const SizedBox(height: 120,)
              ],
            ),
            panel: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: Colors.white,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(
                          Order.getStatusText(s),
                          style: TextStyle(fontSize: 16),
                        ),
                        dense: true,
                        activeColor: Colors.blue[300],
                        value: ordersManager.statusFilter.contains(s),
                        onChanged: (v) {
                          ordersManager.setStatusFilter(
                            status: s,
                            enabled: v,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
          );
        },
      ),
    );
  }
}
