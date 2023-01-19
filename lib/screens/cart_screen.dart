import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/cart_provider.dart';
import 'package:shopapp2/providers/orders_provider.dart';
import 'package:shopapp2/widgets/cart_listview.dart';
import 'package:shopapp2/widgets/main_drawer.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            totalCardBuilder(context, cartData.totalAmount, cartData),
            SizedBox(
              height: 10,
            ),
            CartListView(cartData),
          ],
        ),
      ),
    );
  }
}

// total card builder
Widget totalCardBuilder(
    BuildContext context, double amount, CartProvider cartData) {
  return Card(
    elevation: 5,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total',
            style: Theme.of(context).textTheme.headline5,
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColor,
            avatar: CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                )),
            label: Text(
              '${amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ButtonTheme(
            height: 50,
            minWidth: 150,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: OrderButton(
              cartData: cartData,
            ),
          )
        ],
      ),
    ),
  );
}

class OrderButton extends StatefulWidget {
  final cartData;

  const OrderButton({
    this.cartData,
    Key key,
  }) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cartLength = widget.cartData.cartMap.length;
    return _isLoading
        ? Container(
            width: 150,
            child: Center(child: CircularProgressIndicator()))
        : TextButton(
            onPressed: cartLength == 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<OrdersProvider>(context, listen: false)
                        .addOrder(widget.cartData.cartMap.values.toList(),
                            widget.cartData.totalAmount)
                        .then((_) {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                    widget.cartData.clearCart();
                  },
            child: Text(
              'ORDER NOW',
              style: TextStyle(
                  fontSize: 16,
                  color: cartLength == 0 ? Colors.deepPurple : Colors.white),
            ));
  }
}
