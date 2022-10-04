
import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavs;


  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs? productsData.favoriteItems:productsData.items;
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 3/2,
        mainAxisSpacing: 10,crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
            child: ProductItem());
      },
      itemCount: products.length,
      padding: EdgeInsets.all(10),);
  }
}