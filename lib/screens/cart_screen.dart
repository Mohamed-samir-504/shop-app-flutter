import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: TextStyle(
                    fontSize: 20
                  ),),
                 Spacer(),
                  Chip(label: Text("\$${cart.totalamount}",style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.titleMedium?.color
                  ),),backgroundColor: Theme.of(context).primaryColor,),
                  FlatButton(onPressed:cart.totalamount <= 0?null: () async{
                    await Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalamount);
                    cart.clear();
                  }, child: Text("Order now"),textColor: Theme.of(context).primaryColor)

                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(itemCount: cart.items.length, itemBuilder: (context, index) {
            return CartItemm(cartItem: cart.items.values.toList()[index],productid: cart.items.keys.toList()[index],);

          }))
        ],
      ),
    );
  }
}
