import 'package:flutter/material.dart';
import 'package:shopapp2/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'ProductDetailScreen';

  @override
  Widget build(BuildContext context) {
    var argV = ModalRoute.of(context).settings.arguments as Map;
    Product product = argV['product'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${product.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
                width: double.infinity,
                child: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${product.description}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

//Scaffold(
//      appBar: AppBar(
//        title: Text('${product.title}'),
//      ),
//      body: Column(
//        children: <Widget>[
//          Container(
//              height: 300,
//              width: double.infinity,
//              child: Image.network(
//                product.imageUrl,
//                fit: BoxFit.cover,
//              )),
//          SizedBox(height: 10,),
//          Text('${product.description}', style: TextStyle(fontSize: 20),),
//          SizedBox(height: 10,),
//          Text('\$${product.price}', style: TextStyle(fontSize: 18, color: Colors.grey),),
//        ],
//      ),
//    );
