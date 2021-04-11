import 'package:bhop/screens/base/widget/custom_drawer.dart';
import 'package:bhop/screens/cart/cart_screen.dart';
import 'package:bhop/screens/products/pages/acessorios_product.dart';
import 'package:bhop/screens/products/pages/alongamento_product.dart';
import 'package:bhop/screens/products/pages/cabine_product.dart';
import 'package:bhop/screens/products/pages/motor_product.dart';
import 'package:bhop/screens/products/pages/tips_product.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final TextStyle textStyle = TextStyle(
    color: Colors.black54,
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AcessoriosProduct()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/acessorios.jpeg'),
              ),
              title: Text(
                'Acessórios',
                style: textStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlongamentoProduct()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/alongamento.jpeg'),
              ),
              title: Text(
                'Alongamento',
                style: textStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CabineProduct()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/cabine.jpeg'),
              ),
              title: Text(
                'Cabine',
                style: textStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MotorProduct()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/motor.jpeg'),
              ),
              title: Text(
                'Motor',
                style: textStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TipsProduct()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/tips.jpeg'),
              ),
              title: Text(
                'Tips',
                style: textStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[100],
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CartScreen()));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
