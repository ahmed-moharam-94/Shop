import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/product.dart';
import 'package:shopapp2/widgets/gridview_item.dart';
import '../providers/product_provider.dart';

class ProductsGridView extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductsGridView(this.showFavoritesOnly);



  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(
      context,
    );
    final List<Product> productList = showFavoritesOnly
        ? productsProvider.showFavoritesOnly
        : productsProvider.productsList;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: productList[index], child: GridViewItem());
      },
    );
  }
}
