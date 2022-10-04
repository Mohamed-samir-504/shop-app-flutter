import 'package:flutter/material.dart';

import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 30,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 60,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 20,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 50,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;


  Products(this.authToken,this._items, this.userId);

  List<Product> get items {

    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchandsetData(bool filter ) async {
    var filterString = filter? '':'orderBy="creatorId"&equalTo="$userId"';
    var url = Uri.parse('https://shop-app-e188f-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null)return;
      url = Uri.parse('https://shop-app-e188f-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favresponse = await http.get(url);
      final favData = jsonDecode(favresponse.body);
      extractedData.forEach((key, value) {
        if(!_items.any((element) => element.id == key)){
          _items.add(Product(id: key, description: value["description"],
              title: value["title"], imageUrl: value["imageurl"], price: value["price"],
              isFavorite: favData == null? false: favData[key] ?? false));
          notifyListeners();
        }

      });


    }catch(error){

    }
  }


  Future<void> addProduct(Product product) async{
    final url = Uri.parse("https://shop-app-e188f-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(url, body: json.encode({
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageurl": product.imageUrl,
        "creatorId":userId
      }));
      final newProduct = Product(id: json.decode(response.body)["name"],
          description: product.description,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price
      );
      _items.add(newProduct);

      notifyListeners();
    }catch(error){
      throw error;
    }



  }

  Future<void> updateProduct(String id, Product newproduct) async{
    var index = _items.indexWhere((element) => element.id == id);
    if(index>=0){
      final url = Uri.parse("https://shop-app-e188f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
      await http.patch(url, body: json.encode({
        "title": newproduct.title,
        "description": newproduct.description,
        "price": newproduct.price,
        "imageurl": newproduct.imageUrl
      }));
      _items[index] = newproduct;
    }
    notifyListeners();
  }
  Future<void> deleteProduct(String id) async{
    final url = Uri.parse("https://shop-app-e188f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    await http.delete(url);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

