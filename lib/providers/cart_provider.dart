import 'package:flutter/foundation.dart';
import 'package:shopapp2/providers/cart.dart';
import 'package:shopapp2/providers/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _cartMap = new Map();

  Map<String, Cart> get cartMap {
    return {..._cartMap};
  }

  double get totalAmount {
    double totalAmount = 0;
    _cartMap.values.toList().forEach((product) {
      totalAmount += product.price * product.quantity;
    });
    return totalAmount;
}

int get numberOfProductsInCart {
    int n = 0;
      _cartMap.values.toList().forEach((product) {
        n += product.quantity;
      });
      return n;
    }

  void addToCart(Product product) {
    _cartMap.update(
        product.id,
            (existingValue) => Cart(
            title: existingValue.title,
            price: existingValue.price,
            id: existingValue.id,
            quantity: existingValue.quantity + 1),
        ifAbsent: () => Cart(
            title: product.title,
            price: product.price,
            id: product.id,
            quantity: 1));
    notifyListeners();
  }

  void deleteItem(String id) {
    _cartMap.remove(id);
    print(id);
    notifyListeners();
  }

  void clearCart() {
    _cartMap.clear();
    notifyListeners();
  }

  void deleteSingleItem(String id) {
    if (!_cartMap.containsKey(id)) return;
    else if (_cartMap[id].quantity > 1) {
      _cartMap.update(id, (existing) => Cart(
        id: existing.id,
        title: existing.title,
        price: existing.price,
        quantity: existing.quantity - 1,
      ));
    }
    else {
      _cartMap.remove(id);
    }
    notifyListeners();
  }
}
