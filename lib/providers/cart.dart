import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null? 0: _items.length;
  }

  double get totalamount{
    var sum = 0.0;
    _items.forEach((key, value) {
      sum+=value.price*value.quantity;
    });
    return sum;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(!_items.containsKey(id))return;

    if(_items[id]!.quantity > 1 )
      {
        _items.update(id, (value) =>
            CartItem(id: value.id, title: value.title, quantity: value.quantity - 1, price: value.price));
      }
    else{
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
