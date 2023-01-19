import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/auth_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/product.dart';

class GridViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context);

    return GridTile(
        child: GestureDetector(
          onTap: () => navigateToDetailProductScreen(context, product),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
                placeholder: AssetImage('assets/images/loading.gif'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () async {
              try {
                final token =
                    Provider.of<AuthProvider>(context, listen: false).token;
                final userId =
                    Provider.of<AuthProvider>(context, listen: false).userId;
                await product.toggleFavorite(token, userId);
                Provider.of<ProductsProvider>(context, listen: false)
                    .updateState();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong')));
              }
            },
          ),
          title: Text('${product.title}'),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item Added to The Cart'),
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        textColor: Colors.white,
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .deleteSingleItem(product.id);
                        }),
                  ),
                );
              }),
        ));
  }

 void navigateToDetailProductScreen(BuildContext context, Product product) {
   Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
       arguments: {'product': product});
 }
}
