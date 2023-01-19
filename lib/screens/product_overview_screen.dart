import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/check_widget.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/overview_gridview.dart';
import '../widgets/badge_icon.dart';

enum FilterOption {
  FavoritesOnly,
  ShowAll,
}

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = 'ProductOverviewScreen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoritesOnly = false;
  bool _isLoading = false;
  bool noConnection = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts(false);
    } catch (error) {
      print(error);
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Network Error'),
              content: Text('Please try Again Later'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Reload'),
                ),
              ],
            );
          });
      setState(() {
        noConnection = true;
      });
    } finally {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return noConnection
        ? Scaffold(
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4.0, -4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0),
                    ]),
                height: 200,
                width: 200,
                child: _isLoading
                    ? Container(
                        height: 150,
                        width: 150,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey[800],
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.network_check,
                            size: 70, color: Colors.grey),
                        onPressed: () {
                          fetchData();
                        }),
              ),
            ),
          )
        : CheckWidget(Scaffold(
            appBar: AppBar(
              title: Text('Products OverView'),
              centerTitle: true,
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Show Favorites Only'),
                        value: FilterOption.FavoritesOnly,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOption.ShowAll,
                      ),
                    ];
                  },
                  onSelected: (FilterOption option) {
                    setState(() {
                      if (option == FilterOption.ShowAll)
                        _showFavoritesOnly = false;
                      else
                        _showFavoritesOnly = true;
                    });
                  },
                ),
                Consumer<CartProvider>(
                    builder: (context, cartData, ch) {
                      return Badge(
                          child: ch,
                          value: '${cartData.numberOfProductsInCart}');
                    },
                    child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        })),
              ],
            ),
            drawer: MainDrawer(),
            body: _isLoading
                ? Container(child: Center(child: CircularProgressIndicator()))
                : ProductsGridView(_showFavoritesOnly)));
  }
}
