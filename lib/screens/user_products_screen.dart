import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-prodcuts';
  Future<void> _refreshData(BuildContext ctx) async{
    await Provider.of<Products>(ctx,listen: false).fetchandsetData(false);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text("Your products"),
      actions: [
        IconButton(onPressed: () {
          Navigator.pushNamed(context, EditProductScreen.routeName);
        }, icon: Icon(Icons.add))
      ],),
      drawer: AppDrawer(),

      body: FutureBuilder(
        future: _refreshData(context),
        builder: (ctx,snapshot)=> snapshot.connectionState == ConnectionState.waiting? Center(
          child: CircularProgressIndicator(),
        ): RefreshIndicator(
          onRefresh: () {
            return _refreshData(context);
          },
          child: Consumer(
            builder:(ctx, data,_)=> Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(itemCount: productsData.length, itemBuilder: (context, i) {
                return Column(
                  children: [
                    UserProductItem(product: productsData[i]),
                    Divider()
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
