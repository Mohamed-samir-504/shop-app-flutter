import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../models/product.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl),),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName, arguments: product.id);
            }, icon: Icon(Icons.edit), color: Theme.of(context).primaryColor),
            IconButton(onPressed: () {
              Provider.of<Products>(context, listen: false).deleteProduct(product.id!);
            }, icon: Icon(Icons.delete), color: Theme.of(context).errorColor,)
          ],
        ),
      ),
    );
  }
}
