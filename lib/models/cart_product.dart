import 'package:bhop/models/cart_manager.dart';
import 'package:bhop/models/product.dart';
import 'package:bhop/models/product_size.dart';
import 'package:bhop/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:bhop/screens/mercado_pago/globals.dart' as globals;

class CartProduct extends ChangeNotifier {
  User user;
  CartManager cartManager;

  var mp = MP(globals.mpClientID, globals.mpClientSecret);
  var resultRefIdMP;

  Future<Map<String, dynamic>> preferenceGetMP() async {
    isLoading = true;
    notifyListeners();
 

    var preference = {
      "items": [
        {
          "title": "B-Shop",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": 20
        }
      ],
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

  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
    subtitle = product.subtitle;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    category = document.data['category'] as String;
    subtitle = document.data['subtitle'] as String;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;
    category = map['category'] as String;
    subtitle = map['subtitle'] as String;

    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  final Firestore firestore = Firestore.instance;

  bool isLoading = false;

  String id;

  String category;
  String subtitle;

  String productId;
  int quantity;
  String size;

  num fixedPrice;

  // ignore: sort_unnamed_constructors_first
  CartProduct();

  Product _product;
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  ProductSize get productSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return productSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'subtitle': subtitle,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
      'subtitle': subtitle
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if (product != null && product.deleted) return false;

    final size = productSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
