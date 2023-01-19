import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/widgets/order_item.dart';

import '../providers/orders_provider.dart';
import '../widgets/main_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = 'OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.error != null) {
                return Center(child: Text('error occurd'));
              } else {
                return Container(
                    constraints: BoxConstraints(
                      minHeight: double.infinity,
                      minWidth: double.infinity,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Consumer<OrdersProvider>(
                      builder: (context, orderData, ch) {
                        return ListView.builder(
                            itemCount: orderData.orderList.length,
                            itemBuilder: (context, index) {
                              print(orderData.orderList);
                              return OrderItem(orderData.orderList[index]);
                            });
                      },
                    ));
              }
            }
          },
        ));
  }
}
