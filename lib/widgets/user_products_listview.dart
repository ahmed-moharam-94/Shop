import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/product_provider.dart';
import 'package:shopapp2/screens/edit_screen_2.dart';

class UserProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductsProvider productsData = Provider.of<ProductsProvider>(context);
    return ListView.builder(
      itemCount: productsData.productsList.length,
      itemBuilder: (context, index) {
        var product = productsData.productsList[index];
        return ListTile(

          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          title: Text('${product.title}'),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditScreen2.routeName, arguments: product);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                  onPressed: () async {
                    try {
                      await productsData.deleteProduct(product.id);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something went wrong')));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
