import 'package:flutter/cupertino.dart';

class Cart {
  final String title;
  final String id;
  final double price;
  final int quantity;

  Cart({
    @required this.title,
    @required this.id,
    @required this.price,
    @required this.quantity,
  });
}
