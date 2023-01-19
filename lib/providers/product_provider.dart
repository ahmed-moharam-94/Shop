import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../exceptions/http_exception.dart';
import '../providers/auth_provider.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
String token;
String userId;

  List<Product> _productList = new List();

  List<Product> get productsList {
    return [..._productList];
  }

  List<Product> get showFavoritesOnly {
    return _productList.where((product) => product.isFavorite).toList();
  }

  void updateState() {
    notifyListeners();
  }

  Future<void> fetchProducts([bool filterProducts = false]) async {
    final filterString = filterProducts ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = 'https://shapp-f2306.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      var decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedData == null) return;

      final isFavorite = 'https://shapp-f2306.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(isFavorite);

      final favoriteData = json.decode(favoriteResponse.body);

      List<Product> extractedProducts = new List();
      decodedData.forEach((id, value) {
        extractedProducts.add(
          new Product(
              title: value['title'],
              id: id,
              price: value['price'],
              imageUrl: value['imageUrl'],
              description: value['description'],
            isFavorite: favoriteData == null ? false : favoriteData[id] ?? false,
          ),
        );
      });
      _productList = extractedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    String url = 'https://shapp-f2306.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'description': product.description,
            'creatorId': userId
          }));
      var id = json.decode(response.body)['name'];
      _productList.add(new Product(
          title: product.title,
          id: id,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProductInfo(String id, Product product) async {
    String url = 'https://shapp-f2306.firebaseio.com/products/$id.json?auth=$token';
    var decodeData = json.encode({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl
    });
    await http.patch(url, body: decodeData);

    int index = _productList.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _productList.removeAt(index);
      _productList.insert(
          index,
          new Product(
              title: product.title,
              id: product.id,
              price: product.price,
              imageUrl: product.imageUrl,
              description: product.description));
      print(index);
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    String url = 'https://shapp-f2306.firebaseio.com/products/$id.json?auth=$token';
    int willBeDeletedIndex = _productList.indexWhere((product) => product.id == id);
    Product willBeDeletedProduct = _productList[willBeDeletedIndex];

    _productList.removeAt(willBeDeletedIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _productList.insert(willBeDeletedIndex,  willBeDeletedProduct);
      notifyListeners();
      print(response.statusCode);
      willBeDeletedProduct = null;
      throw HttpException('delete went wrong!');
    }

  }

  void update(AuthProvider authData) {
    token = authData.token;
    userId = authData.userId;
  }
}
