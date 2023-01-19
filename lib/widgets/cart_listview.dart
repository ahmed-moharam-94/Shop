import 'package:flutter/material.dart';
import 'package:shopapp2/widgets/cart_list_item.dart';
import '../providers/cart_provider.dart';

class CartListView extends StatelessWidget {
  final CartProvider cartData;

  CartListView(this.cartData);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: cartData.cartMap.length,
          itemBuilder: (context, index) {
            return CartListItem(cartData, index);
          }),
    );
  }
}
