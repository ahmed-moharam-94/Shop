import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp2/providers/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: showDetails ? widget.order.products.length * 20.0 + 120.0 : 120,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '\$${widget.order.amount}',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      icon: Icon(showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      onPressed: () {
                        setState(() {
                          showDetails = !showDetails;
                        });
                      }
                  )
                ],
              ),
              Text(
                '${DateFormat('yyyy-MM-dd   hh:mm').format(widget.order.dateTime)}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
             AnimatedContainer(
               duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                height: showDetails ? widget.order.products.length * 20.0 + 10.0 : 0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.order.products.map((product) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${product.title}', style: TextStyle(fontSize: 18)),
                          Text('${product.quantity}x  \$${product.price}',  style: TextStyle(fontSize: 18))
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
