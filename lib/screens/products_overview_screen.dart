import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/badge.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var isloaded = false;

  @override
  void initState() {
    isloaded = true;
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context,listen: false).fetchandsetData(true).then((value) {
        setState(() {
          isloaded = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (BuildContext context, cartData, Widget? child) {
              return Badge(child: IconButton(onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              }, icon: Icon(Icons.shopping_cart)),
                  value: cartData.itemCount.toString());
            },

          )
        ],
      ),
      drawer: AppDrawer(),
      body: isloaded? Center(child: CircularProgressIndicator()):ProductsGrid(_showOnlyFavorites),
    );
  }
}
