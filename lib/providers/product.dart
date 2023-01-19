import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String title;
  final String id;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    @required this.title,
    @required this.id,
    @required this.price,
    @required this.imageUrl,
    @required this.description,
    this.isFavorite = false,
  });


  Future<void> toggleFavorite(String token, String userId) async{
    final oldStatue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shapp-f2306.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(url, body: json.encode(
       isFavorite,
      ));
      if (response.statusCode >= 400) {
        print('reached from status code');
        isFavorite = oldStatue;
        notifyListeners();
      }
    } catch (error) {
      print('reached from catch');
      isFavorite = oldStatue;
      notifyListeners();
    }
  }
}
