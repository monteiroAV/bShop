import 'package:bhop/models/product.dart';
import 'package:bhop/models/product_manager.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/cart/cart_screen.dart';
import 'package:bhop/screens/edit_product/ediit_product_screen.dart';
import 'package:bhop/screens/products/components/search_dialog.dart';
import 'package:bhop/screens/products/pages/tile/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotorProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return const Text('Motor');
            } else {
              return LayoutBuilder(
                builder: (_, constrains) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(productManager.search));
                      if (search != null) {
                        productManager.search = search;
                      }
                    },
                    child: Container(
                      width: constrains.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(productManager.search));
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                Product product;
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProductScreen(product)));
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
              itemCount: productManager.filteredProducts.length,
              itemBuilder: (context, index) {
                if (productManager.filteredProducts[index].category ==
                    'motor') {
                  return Column(
                    children: <Widget>[
                      ProductTile(productManager.filteredProducts[index])
                    ],
                  );
                } else {
                  return Container();
                }
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[100],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CartScreen()));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
