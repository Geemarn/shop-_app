import 'package:flutter/foundation.dart';

class Carts {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String url;

  Carts({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.url,
  });
}

class CartsProvider with ChangeNotifier {
  Map<String, Carts> _items = {};
  Map<String, Carts> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmt {
    var _total = 0.0;
    _items.forEach((key, item) {
      _total += item.price * item.quantity;
    });
    return _total;
  }

  void addCart(String productId, String title, double price, String url) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingVal) => Carts(
          id: existingVal.id,
          title: existingVal.title,
          price: existingVal.price,
          quantity: existingVal.quantity + 1,
          url: existingVal.url,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Carts(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
          url: url,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleCart(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => Carts(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          url: existingCartItem.url,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
