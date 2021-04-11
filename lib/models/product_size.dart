class ProductSize {
  ProductSize({this.name, this.price, this.stock});

  ProductSize.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
  }

  String name;
  num price;
  int stock;

  bool get hasStock => stock > 0;

  ProductSize clone() {
    return ProductSize(name: name, stock: stock, price: price);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  @override
  String toString() {
    return 'ProductSize{name: $name, price: $price, stock: $stock}';
  }
}
