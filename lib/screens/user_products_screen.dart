import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_products_listview.dart';

import 'edit_screen_2.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = 'UserProductsScreen';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else
            return RefreshIndicator(
              onRefresh: () => refreshProducts(context),
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Your Products'),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditScreen2.routeName);
                        })
                  ],
                ),
                drawer: MainDrawer(),
                body: UserProductsList(),
              ),
            );
        },
      ),
    );
  }
}
