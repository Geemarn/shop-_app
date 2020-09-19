import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_header.dart';

class Cart extends StatelessWidget {
  static const routeName = '/carts';
  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<CartsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart List')),
      body: Column(children: <Widget>[
        CartHeader(carts: carts),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) {
              return CartItem(
                carts.items.values.toList()[i].id,
                carts.items.keys.toList()[i],
                carts.items.values.toList()[i].title,
                carts.items.values.toList()[i].price,
                carts.items.values.toList()[i].quantity,
                carts.items.values.toList()[i].url,
              );
            },
            itemCount: carts.itemCount,
          ),
        ),
      ]),
    );
  }
}
