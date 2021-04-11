import 'package:bhop/models/address.dart';
import 'package:bhop/models/cart_manager.dart';
import 'package:bhop/models/cart_product.dart';
import 'package:bhop/models/user.dart';
import 'package:bhop/services/cielo_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:bhop/screens/mercado_pago/globals.dart' as globals;

enum Status { canceled, preparing, transporting, delivered }

class Order extends ChangeNotifier{
  CartManager cartManager;
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
          "title": "B-Shop",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": cartManager.totalPrice
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
    //print(resultRefIdMP);

    isLoading = false;
    notifyListeners();

    return resultRefIdMP;
  }


  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;

    status = Status.values[doc.data['status'] as int];

    payId = doc.data['payId'] as String;
  }

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').document(orderId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
     // "refIdMP": resultRefIdMP['response']['id'],
      'payId': payId,
    });
  }

  Function() get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.updateData({'status': status.index});
          }
        : null;
  }

  Function() get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            firestoreRef.updateData({'status': status.index});
          }
        : null;
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);

      status = Status.canceled;
      firestoreRef.updateData({'status': status.index});
    } catch (e) {
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  String orderId;
  String payId;

  List<CartProduct> items;
  num price;

  String userId;

  Address address;

  Timestamp date;

  Status status;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
