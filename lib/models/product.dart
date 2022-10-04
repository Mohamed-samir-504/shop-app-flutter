import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String description;
  final String title;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.description,
      required this.title,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, String userId) async {
    final url = Uri.parse(
        "https://shop-app-e188f-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token");
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        isFavorite = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldstatus;
      notifyListeners();
    }
  }
}
