import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/auth_provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';

class OrdersProvider with ChangeNotifier {
  String token;
  String userId;
  List<Order> _ordersList = new List();

  List<Order> get orderList {
    return [..._ordersList];
  }

  Future<void> addOrder(List<Cart> cartOrder, total) async {
    String url = 'https://shapp-f2306.firebaseio.com/orders/$userId.json?auth=$token';
    final timestamp = DateTime.now();
    var dataEncoded = json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      // mapping products to a list of maps
      'products': cartOrder
          .map((cartOrder) => {
                'title': cartOrder.title,
                'price': cartOrder.price,
                'quantity': cartOrder.quantity,
                'id': cartOrder.id,
              })
          .toList()
    });
    final response = await http.post(url, body: dataEncoded);
    final id = json.decode(response.body)['name'];
    _ordersList.add(Order(
      id: id,
      amount: total,
      products: cartOrder,
      dateTime: timestamp,
    ));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    String url = 'https://shapp-f2306.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    List<Order> _fetchedOrders = [];
    // exist if there is no orders data

    var decodedData = json.decode(response.body) as Map<String, dynamic>;
    if (decodedData == null) return;

    decodedData.forEach((key, value) {
      _fetchedOrders.add(new Order(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((item) => Cart(
                  title: item['title'],
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
//    _fetchedOrders.forEach((order) {
//      order.products.forEach((product) => print(product.title));
//    });
    _ordersList = _fetchedOrders;
    notifyListeners();
  }

  void update(AuthProvider authData) {
    token = authData.token;
    userId = authData.userId;
  }
}

