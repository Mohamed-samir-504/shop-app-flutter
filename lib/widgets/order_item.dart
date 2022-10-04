import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded? Icons.expand_less:Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
            height: min(widget.order.products.length * 20 + 50, 120),
            child: ListView.builder(itemCount: widget.order.products.length, itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.order.products[index].title, style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                  Text("x${widget.order.products[index].quantity}  \$${widget.order.products[index].price}",
                  style: TextStyle(fontSize: 18, color: Colors.grey),)
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
