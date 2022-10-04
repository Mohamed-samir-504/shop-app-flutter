import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemm extends StatelessWidget {
  const CartItemm({Key? key, required this.cartItem, required this.productid}) : super(key: key);

  final CartItem cartItem;
  final String productid;

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).removeItem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(radius: 25,child: FittedBox(child: Text("\$${cartItem.price}")),),
            title: Text(cartItem.title),
            subtitle: Text("Total: \$${(cartItem.price * cartItem.quantity)}"),
            trailing: Text("x${cartItem.quantity}"),

          ),
        ),
      ),
    );
  }
}
