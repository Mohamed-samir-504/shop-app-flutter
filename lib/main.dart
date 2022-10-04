import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_) => Products("", [],""),

            update: (context, auth,previous) => Products(auth.getToken ?? "",previous==null?[]:previous.items,auth.userId?? "")),
        ChangeNotifierProvider(
          create: (context) => Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(create: (context) => Orders("",""),
          update: ( context, auth,  previous) => Orders(auth.getToken??"",auth.userId??""),)
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) =>
         MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.cyan,
              fontFamily: "Lato"),
          home:auth.isAuth?ProductsOverviewScreen(): AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) =>OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context)=> AuthScreen()
          },
        ),
      ),
    );
  }
}
