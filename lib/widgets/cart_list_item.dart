import 'package:flutter/material.dart';

import '../providers/cart_provider.dart';

class CartListItem extends StatelessWidget {
  final CartProvider cartData;
  final int index;

  CartListItem(this.cartData, this.index);

  @override
  Widget build(BuildContext context) {
    var cartList = cartData.cartMap.values.toList();
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(Icons.delete, size: 50, color: Colors.white),
      ),
      onDismissed: (direction) {
        cartData.deleteItem(cartList[index].id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Delete Item'),
                content: Text('Do you want to Permenantly Delete This Item'),
                actions: <Widget>[
                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Yes')),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('No')),
                ],
              );
            });
      },
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '\$${cartList[index].price}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              '${cartList[index].title}',
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
            ),
            subtitle: Text(
              'Total: \$${(cartList[index].price * cartList[index].quantity).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Text(
              '${cartList[index].quantity} x',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
